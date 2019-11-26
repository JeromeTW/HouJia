// UITextFieldExtension.swift
// Copyright (c) 2019 Jerome Hsieh. All rights reserved.
// Created by Jerome Hsieh.

import UIKit

extension UITextField {
  public func setInputViewDatePicker(defaultDate: Date = Date(), maximumDate: Date = Date(), doneTitle: String, cancelTitle: String, target: Any, selector: Selector) {
    // Create a UIDatePicker object and assign to inputView
    let screenWidth = UIScreen.main.bounds.width
    let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
    datePicker.datePickerMode = .date
    datePicker.date = defaultDate
    datePicker.maximumDate = maximumDate
    inputView = datePicker

    // Create a toolbar and assign it to inputAccessoryView
    let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
    let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let cancel = UIBarButtonItem(title: cancelTitle, style: .plain, target: nil, action: #selector(tapCancel))
    let barButton = UIBarButtonItem(title: doneTitle, style: .plain, target: target, action: selector)
    toolBar.setItems([cancel, flexible, barButton], animated: false)
    inputAccessoryView = toolBar
  }

  @objc func tapCancel() {
    resignFirstResponder()
  }
  
  public var textIsNotEmpty: Bool {
    guard let notNilText = text, notNilText.isEmpty == false else {
      return false
    }
    return true
  }
}
