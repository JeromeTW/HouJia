// UIButtonExtension.swift
// Copyright (c) 2019 Jerome Hsieh. All rights reserved.
// Created by Jerome Hsieh.

import UIKit

extension UIButton {
  public func underlineText(_ otherAttrs: [NSAttributedString.Key: Any]? = nil) {
    guard let title = title(for: .normal) else { return }

    let titleString = NSMutableAttributedString(string: title)
    var attrs = [NSAttributedString.Key: Any]()
    if let otherAttrs = otherAttrs {
      attrs = otherAttrs
    }
    attrs[.underlineStyle] = NSUnderlineStyle.single.rawValue
    titleString.addAttributes(attrs, range: NSRange(location: 0, length: title.count))
    setAttributedTitle(titleString, for: .normal)
  }
}

extension UIButton {
  @IBInspectable public var adjustFontSizeToWidth: Bool {
    get {
      return titleLabel!.adjustsFontSizeToFitWidth
    }
    set {
      titleLabel!.adjustsFontSizeToFitWidth = newValue
      titleLabel!.lineBreakMode = .byClipping
    }
  }
}

extension UIButton {
  public func alignImageAndTitleVertically(padding: CGFloat = 6.0) {
    let imageSize = self.imageView!.frame.size
    let titleSize = self.titleLabel!.frame.size
    let totalHeight = imageSize.height + titleSize.height + padding

    self.imageEdgeInsets = UIEdgeInsets(
      top: -(totalHeight - imageSize.height),
      left: 0,
      bottom: 0,
      right: -titleSize.width
    )

    self.titleEdgeInsets = UIEdgeInsets(
      top: 0,
      left: -imageSize.width,
      bottom: -(totalHeight - titleSize.height),
      right: 0
    )
  }
}
