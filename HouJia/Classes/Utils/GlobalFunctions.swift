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

public func getDocumentsDirectory() -> URL {
  let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
  let documentsDirectory = paths.first
  return documentsDirectory!
}

public func getTemporaryDirectory() -> URL {
  return URL(fileURLWithPath: NSTemporaryDirectory())
}
