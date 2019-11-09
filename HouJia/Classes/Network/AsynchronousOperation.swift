// AsynchronousOperation.swift
// Copyright (c) 2019 Jerome Hsieh. All rights reserved.
// Created by Jerome Hsieh.

import Foundation

/// Asynchronous Operation base class
///
/// This class performs all of the necessary KVN of `isFinished` and
/// `isExecuting` for a concurrent `NSOperation` subclass. So, to developer
/// a concurrent NSOperation subclass, you instead subclass this class which:
///
/// - must override `main()` with the tasks that initiate the asynchronous task;
///
/// - must call `completeOperation()` function when the asynchronous task is done;
///
/// - optionally, periodically check `self.cancelled` status, performing any clean-up
///   necessary and then ensuring that `completeOperation()` is called; or
///   override `cancel` method, calling `super.cancel()` and then cleaning-up
///   and ensuring `completeOperation()` is called.

// 可以自己定義何時為 Operation 的完成。
public class AsynchronousOperation: Operation {
  override public var isAsynchronous: Bool { return true }

  private var _executing: Bool = false
  override public var isExecuting: Bool {
    get {
      // 若直接返回 isExecuting 會陷入無限迴圈。
      return _executing
    }
    set {
      // 用 KVN 技術修改父類中本來只能讀不能寫的屬性。
      if _executing != newValue {
        willChangeValue(forKey: "isExecuting")
        _executing = newValue
        didChangeValue(forKey: "isExecuting")
      }
    }
  }

  private var _finished: Bool = false
  override public var isFinished: Bool {
    get {
      return _finished
    }
    set {
      if _finished != newValue {
        willChangeValue(forKey: "isFinished")
        _finished = newValue
        didChangeValue(forKey: "isFinished")
      }
    }
  }

  /// Complete the operation
  ///
  /// This will result in the appropriate KVN of isFinished and isExecuting
  public func completeOperation() {
    logC("completeOperation")
    if isExecuting {
      isExecuting = false
      isFinished = true
    }
  }

  override public func start() {
    logC("start")
    guard isCancelled == false else {
      isFinished = true
      return
    }

    isExecuting = true

    main()
  }

  override public func main() {
    logC("main")
  }
}
