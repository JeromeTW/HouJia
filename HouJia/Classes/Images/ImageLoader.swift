// ImageLoader.swift
// Copyright (c) 2019 Jerome Hsieh. All rights reserved.
// Created by Jerome Hsieh.

import UIKit

public class SypQueue: OperationQueue {
  public var networkOperationFiredCounter = 0 {
    didSet {
      logC("networkOperationFiredCounter: \(networkOperationFiredCounter)")
    }
  }

  override public func addOperation(_ op: Operation) {
    if op is NetworkRequestOperation {
      networkOperationFiredCounter += 1
    }
    super.addOperation(op)
  }
}

public class ImageLoader: NSObject {
  public static let shared = ImageLoader()
  private let imageCache = NSCache<NSString, UIImage>()
  public lazy var requestOperationDictionary = [URL: AsynchronousOperation]()
  public var current: UInt = 0

  public func synchronized(_ lock: AnyObject, _ closure: () -> Void) {
    objc_sync_enter(lock)
    closure()
    objc_sync_exit(lock)
  }

  public func next() -> UInt {
    synchronized(self) {
      current += 1
    }
    return current
  }

  public lazy var queue: SypQueue = {
    var queue = SypQueue()
    queue.name = "ImageLoader"
    queue.maxConcurrentOperationCount = 4
    queue.qualityOfService = QualityOfService.userInitiated
    queue.addObserver(self, forKeyPath: "operationCount", options: .new, context: nil)
    return queue
  }()

  public func imageByURL(_ url: URL, completionHandler: @escaping (_ image: UIImage?, _ url: URL) -> Void) {
    // get image from cache
    if let imageFromCache = imageCache.object(forKey: url.absoluteString as NSString) {
      completionHandler(imageFromCache, url)
      return
    } else {
      // 檢查是否有重複的下載圖片請求
      if let prevoiusOperation = requestOperationDictionary[url] {
        logC("重複請求: \(url)")
//        repeatRequiresHandler(url: url)
      }

      let request = APIRequest(url: url)
      func mainThreadCompletionHandler(image innerImage: UIImage?, _ url: URL) {
        DispatchQueue.main.async {
          completionHandler(innerImage, url)
        }
      }
      let operation = NetworkRequestOperation(request: request) { [weak self] result in
        guard let self = self else {
          assertionFailure()
          return
        }
        guard let operation = self.requestOperationDictionary[url] else {
          mainThreadCompletionHandler(image: nil, url)
          return
        }
        defer {
          self.requestOperationDictionary.removeValue(forKey: url)
        }
        guard operation.isCancelled == false else {
          // 取消的話就不執行 CompletionHandler
          for dependenceOp in operation.dependencies {
            operation.removeDependency(dependenceOp)
          }
          return
        }

        switch result {
        case let .success(response):
          if let data = response.body {
            if let image = UIImage(data: data) {
              self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
              mainThreadCompletionHandler(image: image, url)
            } else {
              logC("Data Format Wrong")
              mainThreadCompletionHandler(image: nil, url)
            }
          } else {
            logC("No Data")
            mainThreadCompletionHandler(image: nil, url)
          }

        case let .failure(error):
          logC(error)
          mainThreadCompletionHandler(image: nil, url)
        }
      }
      requestOperationDictionary[url] = operation
      queue.addOperation(operation)
    }
  }

  public func cancelRequest(url: URL) {
    if let operation = requestOperationDictionary[url] {
      if operation.isExecuting == false {
        requestOperationDictionary.removeValue(forKey: url)
        operation.cancel()
      }
    }
  }

//  private func repeatRequiresHandler(url: URL) {
//    guard requestOperationDictionary[url] == nil else {
//      let prevoiusOperation = requestOperationDictionary[url]!
//      let blockOperation = BlockOperation {
//        DispatchQueue.main.async {
//          [weak self] in
//          guard let self = self else {
//            return
//          }
//          guard let image = self.imageCache.object(forKey: url.absoluteString as NSString) else {
//            fatalError()
//          }
//          completionHandler(image, url)
//        }
//      }
//      blockOperation.addDependency(prevoiusOperation)
//      queue.addOperation(blockOperation)
//      return
//    }
//  }
}

// MARK: - KVO

extension ImageLoader {
  override public func observeValue(forKeyPath _: String?, of _: Any?, change _: [NSKeyValueChangeKey: Any]?, context _: UnsafeMutableRawPointer?) {
    logC("operationCount: \(queue.operationCount)")
  }
}
