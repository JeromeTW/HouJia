// LoginTextFieldViewTests.swift
// Copyright (c) 2019 Jerome Hsieh. All rights reserved.
// Created by Jerome Hsieh.

import XCTest

class LoginTextFieldViewTests: XCTestCase {
  var superview: LoginTextFieldSuperView!
  override func setUp() {
    superview = LoginTextFieldSuperView(frame: CGRect.zero)
  }

  override func tearDown() {
    superview = nil
  }

  func test_LoginTextFieldView_title() {
    let title = "Title"
    superview.title = title
    XCTAssert(superview.loginTextFieldView.label.text == title)
  }

  func test_LoginTextFieldView_placeholder() {
    let placeholder = "Placeholder"
    superview.placeHolder = placeholder
    XCTAssert(superview.loginTextFieldView.textField.placeholder == placeholder)
  }

  func testPerformanceExample() {
    // This is an example of a performance test case.
    measure {
      // Put the code you want to measure the time of here.
    }
  }
}
