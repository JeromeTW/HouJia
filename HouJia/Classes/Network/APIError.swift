//
//  APIError.swift
//  HouJia
//
//  Created by JEROME on 2019/11/12.
//

import Foundation

/// 不在 API 預期範圍內的連線錯誤
enum APIError: Error {
  /// 後台沒有回應
  case noResponse
  
  /// 後台沒有吐回任何資料
  case noData
  
  /// 後台回應了不在 api 規格中的 JSON 資料, 通常可能發生在 api 改版的時候
  case unexpectedJSON(httpStatusCode: Int, json: Any)
  
  /// 其他可能的錯誤
  case unexpectedError(httpStatusCode: Int, dataString: String?)
}

extension APIError: LocalizedError {
  
  /// 本地化字串
  var errorDescription: String? {
    switch self {
    case .noResponse:
      return "伺服器無回應"
    
    case .noData:
      return "伺服器回傳資料為空"
    
    case .unexpectedJSON(let httpStatusCode, let json):
      return "伺服器回傳非預期的 JSON 資料 \(httpStatusCode), \(json)"
      
    case .unexpectedError(let httpStatusCode, let dataString):
      if let dataString = dataString {
        return "發生未預期的錯誤 \(httpStatusCode), \(dataString)"
      } else {
        return "發生未預期的錯誤 \(httpStatusCode)"
      }
    }
  }
}
