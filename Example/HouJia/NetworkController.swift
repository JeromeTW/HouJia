//
//  NetworkController.swift
//  MoshiMember
//
//  Created by JEROME on 2019/11/11.
//  Copyright © 2019 jerome. All rights reserved.
//

import Foundation


struct LoginReponse: Decodable {
  var accessToken: StringFlexible
  var expiresIn: IntFlexible
  var requestAt: StringFlexible
  var tokeyType: StringFlexible
}

class NetworkController: NSObject {
  static let shared = NetworkController()
  lazy var requestOperationDictionary = [URL: AsynchronousOperation]()
  
  lazy var queue: SypQueue = {
    var queue = SypQueue()
    queue.name = "APILoader"
    queue.maxConcurrentOperationCount = 4
    queue.qualityOfService = QualityOfService.userInitiated
    return queue
  }()
  
  private var baseURL: URL {
    #if DEBUG
      return URL(string: "https://express.moshi.com/languages")!
    #else
      return URL(string: "https://express.moshi.com/languages")!
    #endif
  }
  func login(id: String, password: String, type: Int = 0, completionHandler: @escaping ((Result<LoginReponse, APIError>) -> Void)) {
    // 參考：https://express.moshi.com/languages
    let lanCode = "tw"
//    let url = baseURL.appendingPathComponent("/api/login")
    let url = URL(string: "https://ptsv2.com/t/applewatchcat/post")!
    let jsonDic: [String : Any] = [
      "id": id,
      "password": password,
      "type": type,
      "lanCode": lanCode
      ]
    
    guard let request = APIRequest(url: url, jsonDictionary: jsonDic) else {
      assertionFailure()
      return
    }
    let operation = NetworkRequestOperation(request: request) { [weak self] result in
      guard let self = self else {
        assertionFailure()
        return
      }
      guard let operation = self.requestOperationDictionary[url] else {
        logF("operation is not exist. url: \(url)")
        return
      }
      defer {
        self.requestOperationDictionary.removeValue(forKey: url)
      }
      guard operation.isCancelled == false else {
        logF("operation is isCancelled. url: \(url)")
        // 取消的話就不執行 CompletionHandler
        for dependenceOp in operation.dependencies {
          operation.removeDependency(dependenceOp)
        }
        return
      }

      switch result {
      case let .success(response):
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        if let loginReponse = try? decoder.decode(LoginReponse.self, from: response.data) {
          logC(loginReponse)
          completionHandler(.success(loginReponse))
        } else {
          logF("JSON Decode loginReponse failde")
          assertionFailure()
          completionHandler(.failure(.unexpectedJSON(httpStatusCode: response.statusCode, json: String(data: response.data, encoding: .utf8) ?? "")))
        }
      case let .failure(error):
        logE(error)
        completionHandler(.failure(.unknown(error: error)))
      }
    }
    requestOperationDictionary[url] = operation
    queue.addOperation(operation)
  }
  
  func cancelRequest(url: URL) {
    if let operation = requestOperationDictionary[url] {
      if operation.isExecuting == false {
        requestOperationDictionary.removeValue(forKey: url)
        operation.cancel()
      }
    }
  }
}
