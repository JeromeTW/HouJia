//
//  DecodeTests.swift
//  HouJia_Tests
//
//  Created by JEROME on 2019/11/13.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest

class DecodeTests: XCTestCase {
  var decoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    return decoder
  }()
  
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func test_decode_LoginReponse() {
    
    let jsonData =
      """
        {
            "accessToken": "eyJhbGciOiJSUzI1NiIs...O8whNpZFjNRu1JMfnczDK8oHSUxsoPg",
            "expiresIn": 604800,
            "requestAt": "2019/9/24 12:45:43",
            "tokeyType": "Bearer"
        }
    """.data(using: .utf8)!
    
    decode(data: jsonData, type: LoginReponse.self)
  }
  
  func decode<T: Decodable>(data: Data, type: T.Type) {
    if let decodeObject = try? decoder.decode(type, from: data) {
      logC(decodeObject)
      XCTAssertTrue(true, "Pass")
    } else {
      XCTFail()
    }
  }
}
