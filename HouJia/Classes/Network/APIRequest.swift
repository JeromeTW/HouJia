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
}

public struct APIRequest {
  public var url: URL
  public var method: HTTPMethod
  public var queryItems: [URLQueryItem]?
  public var headers: [HTTPHeader]?
  public var body: Data?

  public init(url: URL, method: HTTPMethod = .get, queryItems: [URLQueryItem]? = nil, headers: [HTTPHeader]? = nil, body: Data? = nil) {
    self.url = url
    self.method = method
    self.queryItems = queryItems
    self.headers = headers
    self.body = body
  }

  public init<JSONObject: Encodable>(url: URL, method: HTTPMethod = .get, jsonObject: JSONObject) throws {
    self.url = url
    self.method = method
    body = try JSONEncoder().encode(jsonObject)
  }
}

public struct APIResponse<Body> {
  public let statusCode: Int
  public let body: Body
}

// MARK: - For JSON Object

extension APIResponse where Body == Data? {
  public func decode<BodyType: Decodable>(to _: BodyType.Type) throws -> APIResponse<BodyType> {
    guard let data = body else {
      throw APIError.decodingFailure
    }
    let decodeJSON = try JSONDecoder().decode(BodyType.self, from: data)
    return APIResponse<BodyType>(statusCode: statusCode, body: decodeJSON)
  }
}

public enum APIError: Error {
  case invalidURL
  case requestFailed
  case decodingFailure
  case unknown(error: Error)
}
