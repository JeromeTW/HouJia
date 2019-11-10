// ButtonWithImageAndLabelTests.swift
// Copyright (c) 2019 Jerome Hsieh. All rights reserved.
// Created by Jerome Hsieh.

import XCTest

class ButtonWithImageAndLabelTests: XCTestCase {
  var superview: ButtonWithImageAndLabelSuperView!
  override func setUp() {
    superview = ButtonWithImageAndLabelSuperView(frame: CGRect.zero)
  }

  override func tearDown() {
    superview = nil
  }

  func test_LoginTextFieldView_text() {
    let text = "text"
    superview.text = text
    XCTAssert(superview.buttonWithImageAndLabelView.label.text == text)
  }

  func test_LoginTextFieldView_image() {
    let image = UIImage(color: UIColor.green)
    superview.image = image
    XCTAssert(superview.buttonWithImageAndLabelView.imageView.image == image)
  }

  func test_LoginTextFieldView_imageAndLabelHeight() {
    let imageAndLabelHeight: CGFloat = 66
    superview.imageAndLabelHeight = imageAndLabelHeight
    XCTAssert(superview.buttonWithImageAndLabelView.imageAndLabelHeight.constant == imageAndLabelHeight)
  }

  func test_LoginTextFieldView_font() {
    let font = UIFont.systemFont(ofSize: 20)
    superview.font = font
    XCTAssert(superview.buttonWithImageAndLabelView.label.font == font)
  }

  func test_LoginTextFieldView_name() {
    let name = "name"
    superview.name = name
    XCTAssert(superview.name == name)
    superview.buttonPressedHandler = { innerName in
      XCTAssert(innerName == name)
    }
    superview.buttonPressed()
  }

  func testPerformanceExample() {
    // This is an example of a performance test case.
    measure {
      // Put the code you want to measure the time of here.
    }
  }
}
