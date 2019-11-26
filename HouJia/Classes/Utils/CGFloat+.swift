// CGFloatExtension.swift
// Copyright (c) 2019 Jerome Hsieh. All rights reserved.
// Created by Jerome Hsieh.

import UIKit

extension CGFloat {
  // default
  public static let defaultStatusBarHeight: CGFloat = 20.0
  public static let iPhoneXStatusBarHeight: CGFloat = 44.0
  public static let defaultNavigationBarHeight: CGFloat = .defaultStatusBarHeight + 44.0
  public static let iPhoneXNavigationBarHeight: CGFloat = .iPhoneXStatusBarHeight + 44.0
  public static let defaultTabBarHeight: CGFloat = 49.0
  public static let iPhoneXTabBarHeight: CGFloat = .defaultTabBarHeight + 34.0
  public static let defaultToolBarHeight: CGFloat = 44.0
  public static let iPhoneXToolBarHeight: CGFloat = .defaultToolBarHeight + 39.0
  public static let defaultKeyboardHeight: CGFloat = 216.0
  public static let iPhoneXKeyboardHeight: CGFloat = .defaultKeyboardHeight + 75.0
  // customize
  public static let zero: CGFloat = 0.0
  public static let defaultMargin: CGFloat = 8.0
  public static let defaultViewHeight: CGFloat = 44.0
  public static let defaultCellRowHeight: CGFloat = 44.0
  public static let defaultButtonHeight: CGFloat = 44.0
  public static let defaultCornerRadius: CGFloat = 10.0

  public var negativeValue: CGFloat {
    return (-1.0 * self)
  }

  public static var navagationViewHeight: CGFloat {
    if UIApplication.shared.statusBarOrientation.isPortrait {
      return 44
    } else {
      return 32
    }
  }
}
