//
//  FlexibleObjectTests.swift
//  HouJia_Tests
//
//  Created by JEROME on 2019/11/13.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import XCTest

class FlexibleObjectTests: XCTestCase {
  
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  typealias Mixed = Decodable & CustomStringConvertible
  struct IntFlexibleObject: Mixed {
    var description: String {
      return "string: \(string.value), bool: \(bool.value), int: \(int.value), double: \(double.value)"
    }
    
    var string: IntFlexible
    var bool: IntFlexible
    var int: IntFlexible
    var double: IntFlexible
  }
  
  struct DoubleFlexibleObject: Mixed {
    var description: String {
      return "string: \(string.value), bool: \(bool.value), int: \(int.value), double: \(double.value)"
    }
    
    var string: DoubleFlexible
    var bool: DoubleFlexible
    var int: DoubleFlexible
    var double: DoubleFlexible
  }
  
  var data1: Data {
    let jsonString =
    """
      {
        "string": "eyJhbGciOiJSUzI1NiIsO8whNpZFjNRu1JMfnczDK8oHSUxsoPg",
        "bool": true,
        "int": 2,
        "double": 1.2
      }
    """
    
    return jsonString.data(using: .utf8)!
  }
  
  var data2: Data {
    let jsonString =
    """
      {
        "string": "20",
        "bool": false,
        "int": -2,
        "double": -100.2
      }
    """
    
    return jsonString.data(using: .utf8)!
  }
  
  var data3: Data {
    let jsonString =
    """
      {
        "string": "30.0",
        "bool": false,
        "int": -2,
        "double": -100.2
      }
    """
    
    return jsonString.data(using: .utf8)!
  }
  
  func test_IntFlexible() {
    guard let intFlexibleObject1: FlexibleObjectTests.IntFlexibleObject = decodeObject(data: data1) else {
      XCTFail()
      return
    }
    XCTAssertTrue(intFlexibleObject1.string.value == -1)
    XCTAssertTrue(intFlexibleObject1.bool.value == 1)
    XCTAssertTrue(intFlexibleObject1.int.value == 2)
    XCTAssertTrue(intFlexibleObject1.double.value == 1)
    
    guard let intFlexibleObject2: FlexibleObjectTests.IntFlexibleObject = decodeObject(data: data2) else {
      XCTFail()
      return
    }
    XCTAssertTrue(intFlexibleObject2.string.value == 20)
    XCTAssertTrue(intFlexibleObject2.bool.value == 0)
    XCTAssertTrue(intFlexibleObject2.int.value == -2)
    XCTAssertTrue(intFlexibleObject2.double.value == -100)
    
    guard let intFlexibleObject3: FlexibleObjectTests.IntFlexibleObject = decodeObject(data: data3) else {
      XCTFail()
      return
    }
    XCTAssertTrue(intFlexibleObject3.string.value == -1)
  }
  
  func test_DoubleFlexible() {
    guard let doubleFlexibleObject1: FlexibleObjectTests.DoubleFlexibleObject = decodeObject(data: data1) else {
      XCTFail()
      return
    }
    XCTAssertTrue(doubleFlexibleObject1.string.value == -1)
    XCTAssertTrue(doubleFlexibleObject1.bool.value == 1)
    XCTAssertTrue(doubleFlexibleObject1.int.value == 2)
    XCTAssertTrue(doubleFlexibleObject1.double.value == 1.2)
    
    guard let doubleFlexibleObject2: FlexibleObjectTests.DoubleFlexibleObject = decodeObject(data: data2) else {
      XCTFail()
      return
    }
    XCTAssertTrue(doubleFlexibleObject2.string.value == 20)
    XCTAssertTrue(doubleFlexibleObject2.bool.value == 0)
    XCTAssertTrue(doubleFlexibleObject2.int.value == -2)
    XCTAssertTrue(doubleFlexibleObject2.double.value == -100.2)
    
    guard let doubleFlexibleObject3: FlexibleObjectTests.DoubleFlexibleObject = decodeObject(data: data3) else {
      XCTFail()
      return
    }
    XCTAssertTrue(doubleFlexibleObject3.string.value == 30)
  }
  
  func decodeObject<T: Mixed>(data: Data) -> T? {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    do {
      let object = try decoder.decode(T.self, from: data)
      logT(issue: "FlexibleObjectTests", message: object.description)
      return object
    } catch {
      logE(error)
      return nil
    }
  }
}
