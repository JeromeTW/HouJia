// APIRequest.swift
// Copyright (c) 2019 Jerome Hsieh. All rights reserved.
// Created by Jerome Hsieh.

import Foundation

public enum HTTPMethod: String {
  case get = "GET"
  case post = "POST"
}

public struct HTTPHeader {
  let field: String
  let value: String
  
  public init(field: String, value: String) {
    self.field = field
    self.value = value
  }
}

public struct APIRequest {
  public var url: URL
  public var method: HTTPMethod
  public var headers: [HTTPHeader]?
  public var body: Data?

  public init(url: URL, method: HTTPMethod = .get, headers: [HTTPHeader]? = nil, body: Data? = nil) {
    self.url = url
    self.method = method
    self.headers = headers
    self.body = body
  }
  
  public init?(withoutQueryItemsURL: URL, method: HTTPMethod = .get, queryItems: [URLQueryItem], headers: [HTTPHeader]? = nil, body: Data? = nil) {
    // resolvingAgainstBaseURL == true，URL組件代表完全解析的URL,而不是局部如 "bar/file.html"
    // http://hk.voidcc.com/question/p-yodyelmt-oc.html
    guard var urlComponent = URLComponents(url: withoutQueryItemsURL, resolvingAgainstBaseURL: true) else {
      return nil
    }
    urlComponent.queryItems = queryItems
    guard let fullURL = urlComponent.url else {
      return nil
    }
    self.url = fullURL
    self.method = method
    self.headers = headers
    self.body = body
  }

  public init?(url: URL, jsonDictionary: [String: Any]) {
    self.url = url
    self.method = .post
    self.headers = [HTTPHeader(field: "Content-Type", value: "application/json; charset=utf-8")]
    do {
      let body = try JSONSerialization.data(withJSONObject: jsonDictionary, options: JSONSerialization.WritingOptions(rawValue: 0))
      self.body = body
    } catch {
      logE(error)
      return nil
    }
  }
}

public struct APIResponse {
  public let statusCode: Int
  public let data: Data
  
  public init(statusCode: Int, body: Data) {
    self.statusCode = statusCode
    self.data = body
  }
}
