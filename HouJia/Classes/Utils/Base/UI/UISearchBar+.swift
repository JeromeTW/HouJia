//
//  UISearchBar+.swift
//  HouJia
//
//  Created by JEROME on 2020/1/5.
//

import Foundation

extension UISearchBar {
  public var textField : UITextField? {
    if #available(iOS 13.0, *) {
      return searchTextField
    } else {
      // Fallback on earlier versions
      return value(forKey: "_searchField") as? UITextField
    }
  }
}
