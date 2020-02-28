//
//  HasSafeAreaBottomView.swift
//  HouJia
//
//  Created by JEROME on 2020/2/28.
//

import UIKit

public protocol HasSafeAreaBottomView: UIViewController {
  var safeAreaBottomView: UIView! { get set }
  var safeAreaBottomViewHeightConstraint: NSLayoutConstraint! { get set }

  var bottomViewHeightChangedObserver: NSObjectProtocol? { get set }
  func setupSafeAreaBottomViewHeight(with backgroundColor: UIColor)
  func setupBottomViewHeightChangedObserver()
  func removeBottomViewHeightChangedObserver()
}

extension HasSafeAreaBottomView {
  
  public func setSafeAreaBottomViewHeight() {
    if #available(iOS 11.0, *) {
      let window = UIApplication.shared.keyWindow
      guard let bottomPadding = window?.safeAreaInsets.bottom else {
        assertionFailure()
        return
      }
      safeAreaBottomViewHeightConstraint.constant = bottomPadding
    } else {
      safeAreaBottomViewHeightConstraint.constant = 0
    }
  }
  
  public func setupSafeAreaBottomViewHeight(with backgroundColor: UIColor = .clear) {
    safeAreaBottomView.backgroundColor = backgroundColor
    setSafeAreaBottomViewHeight()
  }
  
  public func setupBottomViewHeightChangedObserver() {
    bottomViewHeightChangedObserver = NotificationCenter.default.addObserver(forName: UIApplication.didChangeStatusBarOrientationNotification, object: nil, queue: nil) { [weak self] _ in
      guard let self = self else { return }
      self.setSafeAreaBottomViewHeight()
    }
  }
  
  public func removeBottomViewHeightChangedObserver() {
    if let observer = bottomViewHeightChangedObserver {
      NotificationCenter.default.removeObserver(observer)
    }
  }
}
