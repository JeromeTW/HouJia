//
//  Copying.swift
//  HouJia
//
//  Created by JEROME on 2020/4/16.
//

import Foundation

// Protocal that copyable class should conform
public protocol Copying {
  init(original: Self)
}

// Concrete class extension
extension Copying {
  // NOTE: Copying 物件的每個屬性都要是 struct, 如果有 class 屬性, 此 class 屬性還需要實作 Copying.
  public func copy() -> Self {
    return Self.init(original: self)
  }
}

// Array extension for elements conforms the Copying protocol
extension Array where Element: Copying {
  public func clone() -> Array {
    var copiedArray = Array<Element>()
    for element in self {
      copiedArray.append(element.copy())
    }
    return copiedArray
  }
}
