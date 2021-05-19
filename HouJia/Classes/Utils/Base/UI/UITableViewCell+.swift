//
//  UITableViewCell.swift
//  GP920_iOS
//
//  Created by Jerome.Hsieh2 on 2018/11/5.
//  Copyright © 2018 Daniel. All rights reserved.
//

import UIKit

extension UITableViewCell {
  public func removeCellSelectionColor() {
    let clearView = UIView()
    clearView.backgroundColor = UIColor.clear
    selectedBackgroundView = clearView
  }
  
  public func separator(hide: Bool) {
    separatorInset.left = hide ? bounds.size.width : 0
  }
}
