//
//  UITextView+.swift
//  HouJia
//
//  Created by JEROME on 2019/12/6.
//

import UIKit

extension UITextView {
  // This method is used for calculating the string's height in a UITextView
  private func heightOf(text: String) -> CGFloat {
    let nsstring: NSString = text as NSString
    let boundingSize = nsstring.boundingRect(
      with: CGSize(width: frame.size.width, height: .greatestFiniteMagnitude),
      options: .usesLineFragmentOrigin,
      attributes: [.font: font!],
      context: nil).size
    return ceil(boundingSize.height + textContainerInset.top + textContainerInset.bottom)
  }
  
  // This method calculates the UITextView's new height
  public func calculateHeightFor(miniLines: Int = 1, maxLines: Int? = nil) -> CGFloat {
    let newString: String = text ?? ""
    let minHeight = heightOf(text: lineString()) // 1 line height
    var maxHeight: CGFloat = .greatestFiniteMagnitude
    if let maxLines = maxLines {
      maxHeight = heightOf(text: lineString(lines: maxLines)) // 6 lines height
    }
    let contentHeight = heightOf(text: newString) // height of the new string
    return min(max(minHeight, contentHeight), maxHeight)
  }
}

public func lineString(lines: Int = 1) -> String {
  guard lines > 1 else {
    return ""
  }
  return String(repeating: "\n", count: lines - 1)
}
