//
//  TextViewTests.swift
//  HouJia_Tests
//
//  Created by JEROME on 2019/12/6.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest

class TextViewTests: XCTestCase {
  
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func test_lineString() {
    let exceptedEmptyArray = [lineString(),
    lineString(lines: 0),
    lineString(lines: 1),
    lineString(lines: -1)]
    for string in exceptedEmptyArray {
      assert(string == "")
    }
    XCTAssertTrue(lineString(lines: 2) == "\n")
    XCTAssertTrue(lineString(lines: 6) == "\n\n\n\n\n")
  }
}
