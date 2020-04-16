//
//  UILabel+Lines.swift
//  GP920_iOS
//
//  Created by Jerome.Hsieh2 on 2018/4/30.
//  Copyright © 2018年 Daniel. All rights reserved.
//

import UIKit

extension UILabel {
  public func calculateMaxLines() -> Int {
    let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
    let charSize = font.lineHeight
    let text = (self.text ?? "") as NSString
    let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
    let lines = Int(textSize.height / charSize)
    return lines
  }
  
  public func set(font: UIFont, text: String, withKerning kerning: CGFloat, lineHeight: CGFloat) {
    self.font = font
    set(text: text, withKerning: kerning)
    setLineHeight(lineHeight: lineHeight)
  }

  public func set(text: String, withKerning kerning: CGFloat) {
    let attributedString = NSMutableAttributedString(string: text)
    attributedString.addAttribute(NSAttributedString.Key.kern, value: kerning, range: NSMakeRange(0, text.count))

    attributedText = attributedString
  }

  public func setLineHeight(lineHeight: CGFloat) {
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = 1.0
    paragraphStyle.lineHeightMultiple = lineHeight
    paragraphStyle.alignment = textAlignment

    let attrString = NSMutableAttributedString()
    if attributedText != nil {
      attrString.append(attributedText!)
    } else {
      let notNilText = text ?? ""
      attrString.append(NSMutableAttributedString(string: notNilText))
      attrString.addAttribute(NSAttributedString.Key.font, value: font ?? UIFont.systemFont(ofSize: 12), range: NSMakeRange(0, attrString.length))
    }
    attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
    attributedText = attrString
  }
}

// MARK: - Label Height
extension UILabel {
  public func textHeight(withWidth width: CGFloat) -> CGFloat {
    guard let text = text else {
      return 0
    }
    return text.height(withWidth: width, font: font)
  }
  
  public func attributedTextHeight(withWidth width: CGFloat) -> CGFloat {
    guard let attributedText = attributedText else {
      return 0
    }
    return attributedText.height(withWidth: width)
  }
}

extension String {
  public func height(withWidth width: CGFloat, font: UIFont) -> CGFloat {
    let maxSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
    let actualSize = self.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [.font : font], context: nil)
    return actualSize.height
  }
}

extension NSAttributedString {
  public func height(withWidth width: CGFloat) -> CGFloat {
    let maxSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
    let actualSize = boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], context: nil)
    return actualSize.height
  }
}
