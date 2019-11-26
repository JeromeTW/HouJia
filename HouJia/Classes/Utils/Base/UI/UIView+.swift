//
//  UIView+.swift
//  HouJia
//
//  Created by JEROME on 2019/11/26.
//

import UIKit

extension UIView {
  public func viewOfType<T: UIView>(type: T.Type) -> [T] {
    if let view = self as? T {
      return [view]
    } else {
      var views = [T]()
      for subView in subviews {
        views += subView.viewOfType(type: type)
      }
      return views
    }
  }
}
