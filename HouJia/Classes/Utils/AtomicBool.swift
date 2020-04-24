//
//  AtomicBool.swift
//  HouJia
//
//  Created by JEROME on 2020/4/24.
//

import Foundation

public final class AtomicBool {
  
  private let lock = DispatchSemaphore(value: 1)
  private var _value: Bool
  
  public init(value initialValue: Bool) {
    _value = initialValue
  }
  
  public var value: Bool {
    get {
      lock.wait()
      defer { lock.signal() }
      return _value
    }
    set {
      lock.wait()
      defer { lock.signal() }
      _value = newValue
    }
  }
  
  public func setTrue() {
    lock.wait()
    defer { lock.signal() }
    _value = true
  }
  
  public func setFalse() {
    lock.wait()
    defer { lock.signal() }
    _value = false
  }
}
