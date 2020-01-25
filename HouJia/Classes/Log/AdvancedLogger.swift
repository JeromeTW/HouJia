// AdvancedLogger.swift
// Copyright (c) 2019 Jerome Hsieh. All rights reserved.
// Created by Jerome Hsieh.

import DeviceGuru
import UIKit
import SSZipArchive

public var logTextView = LogTextView()

public class AdvancedLogger: BaseLogger {
  lazy var queue: SypQueue = {
    var queue = SypQueue()
    queue.name = "LogUploader"
    queue.maxConcurrentOperationCount = 4
    queue.qualityOfService = QualityOfService.userInitiated
    return queue
  }()
  
  override func show(_ logString: String) {
    logTextView.logText += "\n\(logString)"
  }

  override func cache(_ logString: String) {
    do {
      try FileManager.default.saveLog(logString)
    } catch {
      if UnitTesting.isRunning {
        fatalError()
      } else {
        print("⭐️❌: ERROR!!!")
      }
    }
  }
  
  public func sendMessageToSlack(slackURL: URL, text: String) {
    let jsonDic: [String: Any] = [
      "text": text
    ]
    guard let request = APIRequest(url: slackURL, jsonDictionary: jsonDic) else {
      assertionFailure()
      return
    }
    let operation = NetworkRequestOperation(request: request) { [weak self] result in
      guard let self = self else {
        assertionFailure()
        return
      }
      switch result {
      case let .success(response):
        logC("SEND SECCESS")
      case let .failure(error):
        logE(error)
        logC("SEND Fail")
      }
    }
    queue.addOperation(operation)
  }
  
  // NOTE: Channels can be "JJJJJJJJ" or "JJJJJJJJ,CCCCCCCC"
  public func uploadLogFileToSlack(fileName: String, zipPassword: String, slackToken: String, channels: String, comment: String) {
    let url = URL(string: "https://slack.com/api/files.upload")!
    let parameters: [AnyHashable: Any] = [
        "token": slackToken,
        "channels": channels,
        "pretty": 1,
        "initial_comment": comment
    ]
    guard let newURL = url.add(parameters: parameters) else {
      assertionFailure()
      return
    }
    let fileManager = FileManager.default
    if let zipURL = fileManager.makeZipFile(with: fileName, password: zipPassword) {
      do {
        let data = try Data(contentsOf: zipURL)
        let boundary = generateBoundaryString()
        let postFileInfo = PostFileInfo(filePathKey: "file", fileName: "\(fileName).zip", data: data, dataType: getContentType(zipURL))
        let body = createBodyWithParameters(nil, postFileInfo: postFileInfo, boundary: boundary)
        let request = APIRequest(url: newURL, method: .post, headers: [HTTPHeader(field: "Content-Type", value: "multipart/form-data; boundary=\(boundary)")], body: body)
        let tempURL = request.url
        logC("🚀: \(tempURL.absoluteString)")
        let operation = NetworkRequestOperation(request: request) { [weak self] result in
          guard let self = self else {
            assertionFailure()
            return
          }
          defer {
            do {
              try fileManager.removeItem(at: zipURL)
            } catch {
              logE(error)
            }
          }
          switch result {
          case let .success(response):
            logC("UPLOAD SECCESS")
          case let .failure(error):
            logE(error)
            logC("UPLOAD Fail")
          }
        }
        queue.addOperation(operation)
      } catch {
        logE(error)
      }
    }
  }
}

extension FileManager {
  public var cachesDirectory: URL? {
    return urls(for: .cachesDirectory, in: .userDomainMask).first
  }

  func saveLog(_ logString: String) throws {
    guard let cachesDirectory = cachesDirectory else { return }
    let currentDateString = Date().string(format: "yyyy-MM-dd")
    let filePath = cachesDirectory.appendingPathComponent("\(currentDateString).log")

    if fileExists(atPath: filePath.path) { // adding content to file
      let fileHandle = FileHandle(forWritingAtPath: filePath.path)
      let content = "\(logString)\n"
      fileHandle?.seekToEndOfFile()
      fileHandle?.write(content.data(using: .utf8) ?? Data())
    } else { // create new file
      do {
        let infoDictionary = Bundle.main.infoDictionary!
        let version = infoDictionary["CFBundleShortVersionString"]
        let buildNumber = infoDictionary["CFBundleVersion"]
        let header = "Version: \((version as? String)!)\nBuild Number: \((buildNumber as? String)!)\n"
        let APPVersionsHistory = "Versions History: " + UserDefaults.standard.APPVersionsHistory + "\n"
        let deviceGuru = DeviceGuru()
        let deviceName = deviceGuru.hardware()
        let deviceCode = deviceGuru.hardwareString()
        let platform = deviceGuru.platform()
        let deviceInfo = "\(deviceName) - \(deviceCode) - \(platform)\n"
        let content = header + APPVersionsHistory + deviceInfo + "\(logString)\n"
        try content.write(to: filePath, atomically: false, encoding: .utf8)
      } catch {
        throw error
      }
    }
  }
  
  public func makeZipFile(with fileName: String, password: String) -> URL? {
    guard let cachesDirectory = cachesDirectory else { return nil }
    do {
      let fileURLs = try contentsOfDirectory(at: cachesDirectory, includingPropertiesForKeys: nil)

      let filterURLs = fileURLs.filter({ (url) -> Bool in
        url.pathExtension == "log"
      })

      let paths = filterURLs.map({ (url) -> String in
        url.path
      })

      guard paths.isEmpty == false else {
        return nil
      }
      let zipFileName = "\(fileName).zip"
      let zipURL = cachesDirectory.appendingPathComponent(zipFileName)
      SSZipArchive.createZipFile(atPath: zipURL.path, withFilesAtPaths: paths, withPassword: password)
      return zipURL
    } catch {
      logE(error)
      return nil
    }
  }
}

extension UserDefaults {
  public var version: String {
    let infoDictionary = Bundle.main.infoDictionary!
    return infoDictionary["CFBundleShortVersionString"] as! String
  }

  public func setAPPVersionAndHistory() {
    let historyKey = "APPVersionsHistory"
    if var versionHistory = self.string(forKey: historyKey) {
      if lastVersion != version {
        // 如果版本號不同了，記錄在 APPVersionsHistory 中。
        versionHistory += " -> \(version)"
        set(versionHistory, forKey: historyKey)
      }
    } else {
      set(version, forKey: historyKey)
    }
    setAPPVersion()
  }

  public var APPVersionsHistory: String {
    let key = "APPVersionsHistory"
    guard let result = string(forKey: key) else {
      if UnitTesting.isRunning {
        return ""
      } else {
        assertionFailure("Not set APPVersionsHistory")
        return ""
      }
    }
    return result
  }

  func setAPPVersion() {
    let key = "APPVersion"
    set(version, forKey: key)
  }

  var lastVersion: String? {
    let key = "APPVersion"
    return string(forKey: key)
  }
}
