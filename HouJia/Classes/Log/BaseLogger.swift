// BaseLogger.swift
// Copyright (c) 2019 Jerome Hsieh. All rights reserved.
// Created by Jerome Hsieh.

import Foundation

// MARK: - NOTE: Need DateExtension.swift file

public enum LogLevel: CustomStringConvertible {
  case user
  case code
  case trace(issue: String)
  case error(error: Error)
  
  public var description: String {
    switch self {
      case .user:
        return "😂"
      case .code:
        return "💩"
      case .trace:
        return "🦋"
      case .error:
        return "❌"
    }
  }
}

#if TEST
  public let logger = BaseLogger() // Test Target 要測試時用這個
#else
  public let logger = AdvancedLogger() // APP Target 用這個，此包含 UI 和 Log 檔案儲存。
#endif

public class BaseLogger {
  // MARK: - Properties
  public var shouldShow = false
  public var shouldCache = false

  init() {}

  // MARK: - Public method

  public func configure(shouldShow: Bool = false, shouldCache: Bool = false) {
    self.shouldShow = shouldShow
    self.shouldCache = shouldCache
  }

  func log(_ message: Any, level: LogLevel, file: String, function: String, line: Int) {
    let fileName = file.components(separatedBy: "/").last?.components(separatedBy: ".").first ?? ""
    var logString = "⭐️\(level.description): "
    switch level {
      case .user:
      //      CLSLogv("user: \(items)", getVaList([]))
        #if DEBUG
          logString += "\(message)"
          print(logString)
        #endif
      case .code:
//        CLSLogv("code: \(fileName) [\(line)], [\(function)]: \(message)", getVaList([]))
        #if DEBUG
          logString += "\(fileName) [\(line)], [\(function)]: \(message)"
          print(logString)
        #endif
      case .trace(let issue):
        #if DEBUG
          logString += "\(issue), \(Date().string(format: "HH:mm:ss")): \(message)"
          print(logString)
        #endif
      case .error(let error):
//        Crashlytics.sharedInstance().recordError(error,
//                                                 withAdditionalUserInfo: ["error_detail": "\(fileName) [\(line)], [\(function)]: \(message), error: \(error.localizedDescription)"])
        #if DEBUG
          logString += "\(fileName) [\(line)], [\(function)]: \(message), error: \(error.localizedDescription)"
          print(logString)
        #endif
    }
    

    if shouldShow {
      self.show(logString)
    }

    if shouldCache {
      cache(logString)
    }
  }

  func show(_: String) {} // 在 AdvancedLogger 中實作
  func cache(_: String) {} // 在 AdvancedLogger 中實作
}

public func logU(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
  logger.log(message, level: .user, file: file, function: function, line: line)
}

public func logC(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
  logger.log(message, level: .code, file: file, function: function, line: line)
}

public func logT(issue: String = "", message: Any, file: String = #file, function: String = #function, line: Int = #line) {
  logger.log(message, level: .trace(issue: issue), file: file, function: function, line: line)
}

public func logE(_ message: Any = "", error: Error, file: String = #file, function: String = #function, line: Int = #line) {
  logger.log(message, level: .error(error: error), file: file, function: function, line: line)
}
