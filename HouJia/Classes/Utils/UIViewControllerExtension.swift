// UIViewControllerExtension.swift
// Copyright (c) 2019 Jerome Hsieh. All rights reserved.
// Created by Jerome Hsieh.

import UIKit

// MARK: - Hide Keyboard When Tapped Around

extension UIViewController {
  /// Hide Keyboard When Tapped View Controller other Place.
  public func hideKeyboardWhenTappedAround() {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardFunc))
    view.addGestureRecognizer(tap)
  }

  /// Dismiss Keyboard Function.
  @objc func dismissKeyboardFunc() {
    view.endEditing(true)
  }
}
