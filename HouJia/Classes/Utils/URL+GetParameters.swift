//
//  URL+GetParameters.swift
//  GP920_iOS
//
//  Created by Jerome.Hsieh2 on 2018/7/10.
//  Copyright © 2018年 Daniel. All rights reserved.
//

import Foundation

extension URL {
  public var queryParameters: [String: String]? {
    guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true), let queryItems = components.queryItems else {
      return nil
    }

    var parameters = [String: String]()
    for item in queryItems {
      parameters[item.name] = item.value
    }

    return parameters
  }

  public func getFullURL() -> URL {
    var urlString = absoluteString
    if urlString.hasPrefix("http://") || urlString.hasPrefix("https://") {
      return self
    } else {
      urlString = "http://" + urlString
      return URL(string: urlString)!
    }
  }
}
