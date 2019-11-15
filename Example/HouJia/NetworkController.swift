//
//  NetworkController.swift
//  MoshiMember
//
//  Created by JEROME on 2019/11/11.
//  Copyright © 2019 jerome. All rights reserved.
//

import Foundation

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
  
  func cancelRequest(url: URL) {
    if let operation = requestOperationDictionary[url] {
      if operation.isExecuting == false {
        requestOperationDictionary.removeValue(forKey: url)
        operation.cancel()
      }
    }
  }
  
  private func checkOperationAvailable(url: URL) -> Bool {
    guard let operation = self.requestOperationDictionary[url] else {
      logF("operation is not exist. url: \(url)")
      return false
    }
    guard operation.isCancelled == false else {
      logF("operation is isCancelled. url: \(url)")
      // 取消的話就不執行 CompletionHandler
      for dependenceOp in operation.dependencies {
        operation.removeDependency(dependenceOp)
      }
      return false
    }
    return true
  }

  private func handlerResponseError(_ error: APIError) {
    logE(error)
    var errorMessage = error.errorDescription ?? ""
    switch error {
    case let .unexpectedJSON(_, data):
      if let string = String(data: data, encoding: .utf8) {
        errorMessage += "\n" + string
      }
    case let .unexpectedError(httpStatusCode, data):
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .iso8601
      if httpStatusCode == 400, let badRequestReponse = try? decoder.decode(BadRequestReponse.self, from: data) {
        errorMessage = badRequestReponse.message.value
      } else if let string = String(data: data, encoding: .utf8) {
        errorMessage += "\n" + string
      }
    default:
      break
    }
    assert(errorMessage != "")
  }
}

// MARK: - Login

extension NetworkController {
  func login(id: String, password: String, type: Int = 0, completionHandler: @escaping ((Result<LoginReponse, APIError>) -> Void)) {
    // 參考：https://express.moshi.com/languages
    let lanCode = "tw"
    
//    let url = baseURL.appendingPathComponent("/api/login")
    // For Tests http://ptsv2.com/t/applewatchcat#
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
      defer {
        self.requestOperationDictionary.removeValue(forKey: url)
      }
      guard self.checkOperationAvailable(url: url) else {
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
          let error = APIError.unexpectedJSON(httpStatusCode: response.statusCode, json: response.data)
          self.handlerResponseError(error)
          assertionFailure()
        }
      case let .failure(error):
        self.handlerResponseError(error)
        completionHandler(.failure(error))
      }
    }
    requestOperationDictionary[url] = operation
    queue.addOperation(operation)
  }
  
  func verifySend(type: String, completionHandler: @escaping ((Result<VerifySendReponse, APIError>) -> Void)) {
    let url = baseURL.appendingPathComponent("/api/sendverify")
    // For Tests http://ptsv2.com/t/applewatchcat#
//    let url = URL(string: "https://ptsv2.com/t/verifySend/post")!
    let jsonDic: [String : Any] = [
      "type": type
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
      defer {
        self.requestOperationDictionary.removeValue(forKey: url)
      }
      guard self.checkOperationAvailable(url: url) else {
        return
      }
      
      switch result {
      case .success(let response):
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        if let loginReponse = try? decoder.decode(VerifySendReponse.self, from: response.data) {
          logC(loginReponse)
          completionHandler(.success(loginReponse))
        } else {
          logF("JSON Decode loginReponse failde")
          let error = APIError.unexpectedJSON(httpStatusCode: response.statusCode, json: response.data)
          self.handlerResponseError(error)
          assertionFailure()
        }
      case .failure(let error):
        self.handlerResponseError(error)
      }
    }
    requestOperationDictionary[url] = operation
    queue.addOperation(operation)
  }
}

struct LoginReponse: Decodable {
  var accessToken: StringFlexible
  var expiresIn: IntFlexible
  var requestAt: StringFlexible
  var tokeyType: StringFlexible
}

struct VerifySendReponse: Decodable {
  var type: StringFlexible
}

struct BadRequestReponse: Decodable {
  var message: StringFlexible
}
