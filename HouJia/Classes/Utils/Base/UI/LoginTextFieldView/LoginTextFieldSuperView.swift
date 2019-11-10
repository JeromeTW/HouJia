// LoginTextFieldSuperView.swift
// Copyright (c) 2019 Jerome Hsieh. All rights reserved.
// Created by Jerome Hsieh.

import UIKit

@IBDesignable public class LoginTextFieldSuperView: UIView {
  public weak var loginTextFieldView: LoginTextFieldView!
  public var title = "" {
    didSet {
      loginTextFieldView.label.text = title
    }
  }

  public var placeHolder: String? {
    didSet {
      loginTextFieldView.textField.placeholder = placeHolder
    }
  }

  override public init(frame: CGRect) {
    super.init(frame: frame)
    addXibView()
  }

  required public init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override public func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
    addXibView()
  }

  override public func awakeFromNib() {
    super.awakeFromNib()
    addXibView()
  }

  public func addXibView() {
    if let loginTextFieldView = Bundle(for: LoginTextFieldView.self).loadNibNamed(LoginTextFieldView.className, owner: nil, options: nil)?.first as? LoginTextFieldView {
      self.loginTextFieldView = loginTextFieldView
      addSubview(loginTextFieldView)
      loginTextFieldView.frame = bounds
    }
  }
}
