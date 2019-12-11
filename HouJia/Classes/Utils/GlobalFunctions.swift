//
//  GlobalFunctions.swift
//  HouJia
//
//  Created by JEROME on 2019/12/11.
//

import Foundation

public func assertNotNil(_ items: Optional<Any>...) {
  for item in items {
    assert(item != nil)
  }
}
