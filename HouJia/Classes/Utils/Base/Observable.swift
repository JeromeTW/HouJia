// Observable.swift
// Copyright (c) 2019 Jerome Hsieh. All rights reserved.
// Created by Jerome Hsieh.

import Foundation

public class Observable<T> {
  public var value: T {
    didSet {
      DispatchQueue.main.async {
        self.valueChanged?(self.value)
      }
    }
  }

  private var valueChanged: ((T) -> Void)?

  public init(value: T) {
    self.value = value
  }

  public func addObserver(willPerfromImmediately: Bool = true, _ onChange: ((T) -> Void)?) {
    valueChanged = onChange
    if willPerfromImmediately {
      onChange?(value)
    }
  }

  public func removeObserver() {
    valueChanged = nil
  }
}
