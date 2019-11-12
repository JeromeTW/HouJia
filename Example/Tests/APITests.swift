//
//  APITests.swift
//  Tests
//
//  Created by JEROME on 2019/11/12.
//  Copyright © 2019 jerome. All rights reserved.
//

import XCTest

class APITests: XCTestCase {
  let networkController = NetworkController.shared
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func test_login_api() {
    let exp = expectation(description: "request successfully")
    networkController.login(id: "asdsa", password: "asdsadsa") {
      result in
      switch result {
      case .success(let response):
        exp.fulfill()
      case .failure(let error):
        logE(error)
      }
      
    }
    wait(for: [exp], timeout: 5)
  }
  
}
