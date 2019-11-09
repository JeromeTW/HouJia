// AdvancedLogger.swift
// Copyright (c) 2019 Jerome Hsieh. All rights reserved.
// Created by Jerome Hsieh.

import DeviceGuru
import UIKit

#if !TEST
  public var logTextView = LogTextView()
#endif

public class AdvancedLogger: BaseLogger {
  override func show(_ logString: String) {
    logTextView.text += "\n\(logString)"
  }

  override func cache(_ logString: String) {
    do {
      try FileManager.default.saveLog(logString)
    } catch {
      logE("", error: error)
    }
  }
}

extension FileManager {
  public var cachesDirectory: URL? {
    return urls(for: .cachesDirectory, in: .userDomainMask).first
  }

  func saveLog(_ logString: String) throws {
    guard let cachesDirectory = cachesDirectory else { return }
    let currentDateString = Date().string(format: "yyyy/MM/dd")
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
      assertionFailure("Not set APPVersionsHistory")
      return ""
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
