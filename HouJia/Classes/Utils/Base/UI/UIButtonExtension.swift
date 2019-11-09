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
