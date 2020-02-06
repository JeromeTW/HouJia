// JeromeNavigationBar.swift
// Copyright (c) 2019 Jerome Hsieh. All rights reserved.
// Created by Jerome Hsieh.

import UIKit

extension UIViewController {
  public func addJeromeNavigationBar() {}
}

/* NOTE: 如果 ContentView 是 ScrollView 並且想要有 JeromeNavigationBar 半透明的壓在 ScrollView 上。需要進行一下操作：
 1. contentView 與 VC.view top 對齊。
 2. scrollView.contentInset = UIEdgeInsets(top: CGFloat.statusAndNavigationTotalHeight - 1, left: 0, bottom: 0, right: 0)
 3. scrollView.contentInsetAdjustmentBehavior = .never
 */
public protocol HasJeromeNavigationBar: UIViewController {
  var topView: UIView! { get set }
  var statusView: UIView! { get set }
  var navagationView: UIView! { get set }
  var contentView: UIView! { get set }
  var safeAreaBottomView: UIView! { get set }
  var statusViewHeightConstraint: NSLayoutConstraint! { get set }
  var navagationViewHeightConstraint: NSLayoutConstraint! { get set }
  var safeAreaBottomViewHeightConstraint: NSLayoutConstraint! { get set }
  var observer: NSObjectProtocol? { get set }
  var shouldSetTopViewToDefaultStyle: Bool! { get set }

  func setupHasJeromeNavigationBarVC(shouldSetTopViewToDefaultStyle: Bool)
  func setupSatusBarFrameChangedObserver()
  func setupSafeAreaBottomViewHeight()
  func removeSatusBarHeightChangedObserver()
  func setTopViewToDefaultStyle() // 設定成跟系統類似的 Style
}

extension HasJeromeNavigationBar {
  public func setupHasJeromeNavigationBarVC(shouldSetTopViewToDefaultStyle: Bool) {
    self.shouldSetTopViewToDefaultStyle = shouldSetTopViewToDefaultStyle
    setupSafeAreaBottomViewHeight()
    setupSatusBarFrameChangedObserver()
  }
  
  public func setupSafeAreaBottomViewHeight() {
    if #available(iOS 11.0, *) {
      let window = UIApplication.shared.keyWindow
//      let topPadding = window?.safeAreaInsets.top
      guard let bottomPadding = window?.safeAreaInsets.bottom else {
        assertionFailure()
        return
      }
      safeAreaBottomViewHeightConstraint.constant = bottomPadding
    } else {
      safeAreaBottomViewHeightConstraint.constant = 0
    }
  }
  
  public func setupSatusBarFrameChangedObserver() {
    let statusHeight = UIApplication.shared.statusBarFrame.size.height
    statusViewHeightConstraint.constant = statusHeight
    navagationViewHeightConstraint.constant = CGFloat.navagationViewHeight
    observer = NotificationCenter.default.addObserver(forName: UIApplication.willChangeStatusBarFrameNotification, object: nil, queue: nil) { [weak self] _ in
      guard let self = self else { return }
      if self.shouldSetTopViewToDefaultStyle {
        DispatchQueue.main.async {
          self.setTopViewToDefaultStyle()
        }
      }
    }
  }

  public func setTopViewToDefaultStyle() {
    topView.backgroundColor = .clear
    let defaultNavigationBarColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 0.5)

    navagationView.removeToolBar()
    statusView.removeToolBar()

    let toolbar1 = UIToolbar(frame: navagationView.bounds)
    toolbar1.setShadowImage(UIImage(), forToolbarPosition: .any)
    navagationView.backgroundColor = defaultNavigationBarColor
    navagationView.insertSubview(toolbar1, at: 0)

    let toolbar2 = UIToolbar(frame: statusView.bounds)
    toolbar2.setShadowImage(UIImage(), forToolbarPosition: .any)
    statusView.backgroundColor = defaultNavigationBarColor
    statusView.insertSubview(toolbar2, at: 0)
  }

  public func removeSatusBarHeightChangedObserver() {
    if let observer = observer {
      NotificationCenter.default.removeObserver(observer)
    }
  }
}

extension UIView {
  public func removeToolBar() {
    for subview in subviews where subview is UIToolbar {
      subview.removeFromSuperview()
    }
  }

  func removeSubviews() {
    for subview in subviews {
      subview.removeFromSuperview()
    }
  }
}
