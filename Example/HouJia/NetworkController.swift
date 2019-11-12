//
//  NetworkController.swift
//  MoshiMember
//
//  Created by JEROME on 2019/11/11.
//  Copyright © 2019 jerome. All rights reserved.
//

import Foundation


struct LoginReponse: Codable {
  var accessToken: String
  var expiresIn: Int
  var requestAt: String
  var tokeyType: String
}

extension APIError {
  
}
class NetworkController: NSObject {
  static let shared = NetworkController()
  lazy var requestOperationDictionary = [URL: AsynchronousOperation]()
//  var current: UInt = 0
  
//  func synchronized(_ lock: AnyObject, _ closure: () -> Void) {
//    objc_sync_enter(lock)
//    closure()
//    objc_sync_exit(lock)
//  }
//
//  func next() -> UInt {
//    synchronized(self) {
//      current += 1
//    }
//    return current
//  }
  
  lazy var queue: SypQueue = {
    var queue = SypQueue()
    queue.name = "APILoader"
    queue.maxConcurrentOperationCount = 4
    queue.qualityOfService = QualityOfService.userInitiated
//    queue.addObserver(self, forKeyPath: "operationCount", options: .new, context: nil)
    return queue
  }()
  
  private var baseURL: URL {
    #if DEBUG
      return URL(string: "https://express.moshi.com/languages")!
    #else
      return URL(string: "https://express.moshi.com/languages")!
    #endif
  }
// , completionHandler: @escaping (_ image: UIImage?, _ url: URL) -> Void
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
//        mainThreadCompletionHandler(image: nil, url)
        return
      }
      defer {
        self.requestOperationDictionary.removeValue(forKey: url)
      }
      guard operation.isCancelled == false else {
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
        } else {
          logF("JSON Decode loginReponse failde")
          assertionFailure()
        }
      case let .failure(error):
        logE(error)
//        logger.log(error.localizedDescription, theOSLog: .image, level: .error)
//        mainThreadCompletionHandler(image: nil, url)
      }
    }
    requestOperationDictionary[url] = operation
    queue.addOperation(operation)
    // Response
//    {
//        "accessToken": "eyJhbGciOiJSUzI1NiIs...O8whNpZFjNRu1JMfnczDK8oHSUxsoPg",
//        "expiresIn": 604800,
//        "requestAt": "2019/9/24 12:45:43"
//        "tokeyType": "Bearer"
//    }
  }
  
  func cancelRequest(url: URL) {
    if let operation = requestOperationDictionary[url] {
      if operation.isExecuting == false {
        requestOperationDictionary.removeValue(forKey: url)
        operation.cancel()
      }
    }
  }
  
//  private func repeatRequiresHandler(url: URL) {
//    guard requestOperationDictionary[url] == nil else {
//      let prevoiusOperation = requestOperationDictionary[url]!
//      let blockOperation = BlockOperation {
//        DispatchQueue.main.async {
//          [weak self] in
//          guard let self = self else {
//            return
//          }
//          guard let image = self.imageCache.object(forKey: url.absoluteString as NSString) else {
//            fatalError()
//          }
//          completionHandler(image, url)
//        }
//      }
//      blockOperation.addDependency(prevoiusOperation)
//      queue.addOperation(blockOperation)
//      return
//    }
//  }
}

// MARK: - KVO

//extension ImageLoader {
//  override func observeValue(forKeyPath _: String?, of _: Any?, change _: [NSKeyValueChangeKey: Any]?, context _: UnsafeMutableRawPointer?) {
//    logger.log("operationCount: \(queue.operationCount)", theOSLog: .image)
//  }
//}
