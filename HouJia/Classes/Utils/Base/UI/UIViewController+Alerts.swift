// UIViewController+Alerts.swift
// Copyright (c) 2019 Jerome Hsieh. All rights reserved.
// Created by Jerome Hsieh.

import Foundation
import UIKit

extension UIViewController {
  public typealias VoidHandler = () -> Void
  public typealias TextFieldHandler = ([UITextField]) -> Void
  public typealias ActionHandler = ((UIAlertAction) -> Void)?

  public struct TextFieldData {
    var text: String?
    var placeholder: String?
    
    public init(text: String?, placeholder: String?) {
      self.text = text
      self.placeholder = placeholder
    }
  }

  /// Show alert view controller with actions.
  ///
  /// - Parameters:
  ///   - title: alert title.
  ///   - message: alert message.
  ///   - textColor: text color.
  ///   - actions: action array.
  public func showAlertWithActions(_ title: String?, message: String?, textColor: UIColor? = nil, actions: [UIAlertAction]) {
    DispatchQueue.main.async {
      let alert = UIAlertController(title: title,
                                    message: message,
                                    preferredStyle: .alert)

      for action in actions {
        alert.addAction(action)
      }

      if let textColor = textColor {
        alert.view.tintColor = textColor
        self.present(alert, animated: true) {
          alert.view.tintColor = textColor
        }
      } else {
        self.present(alert, animated: true)
      }
    }
  }

  public func showOKAlert(_ title: String?, message: String?, okTitle: String) {
    showAlertWithActions(title, message: message, actions: [UIAlertAction(title: okTitle, style: .default)])
  }

  public func showOKAlert(_ title: String?,
                   message: String?,
                   okTitle: String,
                   okHandler: ((UIAlertAction) -> Void)? = nil) {
    let alert = UIAlertController(title: title,
                                  message: message,
                                  preferredStyle: .alert)
    let okAction = UIAlertAction(title: okTitle, style: .default, handler: okHandler)
    alert.addAction(okAction)
    present(alert, animated: true)
  }

  /// Show alert view controller with textfields.
  ///
  /// - Parameters:
  ///   - title: alert title.
  ///   - message: alert message.
  ///   - textColor: text color.
  ///   - textFieldsData: textFieldsData array.
  public func showAlertController(withTitle title: String?,
                           message: String?,
                           textColor: UIColor? = nil,
                           textFieldsData: [TextFieldData],
                           leftTitle: String,
                           leftHandler: TextFieldHandler?,
                           rightTitle: String,
                           rightHandler: TextFieldHandler?) {
    DispatchQueue.main.async {
      let alert = UIAlertController(title: title,
                                    message: message,
                                    preferredStyle: .alert)

      var textfields = [UITextField]()
      for textFieldData in textFieldsData {
        alert.addTextField { (textField) -> Void in
          textField.text = textFieldData.text
          textField.placeholder = textFieldData.placeholder
          textField.clearButtonMode = .whileEditing
          textfields.append(textField)
        }
      }

      let left = UIAlertAction(title: leftTitle, style: .default) { _ in
        leftHandler?(textfields)
      }

      let right = UIAlertAction(title: rightTitle, style: .default) { _ in
        rightHandler?(textfields)
      }

      alert.addAction(left)
      alert.addAction(right)

      if let textColor = textColor {
        alert.view.tintColor = textColor
        self.present(alert, animated: true) {
          alert.view.tintColor = textColor
        }
      } else {
        self.present(alert, animated: true)
      }
    }
  }

  public func showAlertController(title: String,
                           message: String?,
                           okTitle: String,
                           cancelTitle: String,
                           okHandler: (() -> Void)? = nil,
                           cancelHandelr: (() -> Void)? = nil,
                           completion: (() -> Void)? = nil) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

    let okAction = UIAlertAction(title: okTitle, style: .default) { (_) -> Void in
      okHandler?()
    }

    let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { _ in
      cancelHandelr?()
    }

    alertController.addAction(okAction)
    alertController.addAction(cancelAction)

    present(alertController, animated: true) { () -> Void in
      completion?()
    }
  }
}
