// ButtonWithImageAndLabelSuperView.swift
// Copyright (c) 2019 Jerome Hsieh. All rights reserved.
// Created by Jerome Hsieh.

import UIKit

@IBDesignable public class ButtonWithImageAndLabelSuperView: UIView {
  public weak var buttonWithImageAndLabelView: ButtonWithImageAndLabelView!
  public var text: String? {
    didSet {
      buttonWithImageAndLabelView.label.text = text
    }
  }

  public var image: UIImage? {
    didSet {
      buttonWithImageAndLabelView.imageView.image = image
    }
  }

  public var imageAndLabelHeight: CGFloat = 55 {
    didSet {
      buttonWithImageAndLabelView.imageAndLabelHeight.constant = imageAndLabelHeight
    }
  }

  public var font: UIFont = UIFont.systemFont(ofSize: 12) {
    didSet {
      buttonWithImageAndLabelView.label.font = font
    }
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
    if let buttonWithImageAndLabelView = Bundle(for: ButtonWithImageAndLabelView.self).loadNibNamed(ButtonWithImageAndLabelView.className, owner: nil, options: nil)?.first as? ButtonWithImageAndLabelView {
      self.buttonWithImageAndLabelView = buttonWithImageAndLabelView
      addSubview(buttonWithImageAndLabelView)
      buttonWithImageAndLabelView.frame = bounds
    }
  }
}
