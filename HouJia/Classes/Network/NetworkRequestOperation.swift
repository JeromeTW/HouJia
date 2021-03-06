// NetworkRequestOperation.swift
// Copyright (c) 2019 Jerome Hsieh. All rights reserved.
// Created by Jerome Hsieh.

import Foundation

public class NetworkRequestOperation: AsynchronousOperation {
  public var data: Data?
  public var error: NSError?

  public var startDate: Date!
  private var task: URLSessionTask!
  private var incomingData = NSMutableData()
  private var session: URLSession = {
    let config = URLSessionConfiguration.default
    config.requestCachePolicy = .reloadIgnoringLocalCacheData
    config.urlCache = nil
    return URLSession(configuration: config)
  }()

  public init(request: APIRequest, completionHandler: @escaping ((Result<APIResponse, APIError>) -> Void)) {
    super.init()

    var urlRequest = URLRequest(url: request.url)
    urlRequest.httpMethod = request.method.rawValue
    urlRequest.httpBody = request.body

    request.headers?.forEach { urlRequest.addValue($0.value, forHTTPHeaderField: $0.field) }

    task = session.dataTask(with: urlRequest) { [weak self] data, response, error in
      guard let self = self else { return }
      defer {
        self.completeOperation()
      }
      if let error = error {
        completionHandler(.failure(.unknown(error: error)))
        return
      }

      guard let httpResponse = response as? HTTPURLResponse else {
        completionHandler(.failure(.noResponse))
        return
      }
      
      guard let noEmptyData = data else {
        completionHandler(.failure(.noData))
        return
      }
      
      guard httpResponse.statusCode / 100 == 2 else {
        completionHandler(.failure(.unexpectedError(httpStatusCode: httpResponse.statusCode, data: noEmptyData)))
        return
      }
      
      completionHandler(.success(APIResponse(statusCode: httpResponse.statusCode, body: noEmptyData, httpResponse: httpResponse)))
    }
  }

  override public func cancel() {
    logC("task.cancel()\n")
    task.cancel()
    super.cancel()
    completeOperation()
  }

  override public func main() {
    logC("task.resume()\n")
    task!.resume()
    startDate = Date()
    super.main()
  }
}
