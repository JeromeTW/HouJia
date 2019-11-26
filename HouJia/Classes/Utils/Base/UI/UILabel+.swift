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
}
