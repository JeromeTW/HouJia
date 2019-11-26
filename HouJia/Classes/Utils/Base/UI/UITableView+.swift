//
//  UITableView.swift
//  GP920_iOS
//
//  Created by Howard on 2016/8/3.
//  Copyright © 2016年 Daniel. All rights reserved.
//

import UIKit

extension UITableView {
  public func scrollToBottom(animated: Bool = true) {
    let section = numberOfSections
    if section > 0 {
      let row = numberOfRows(inSection: section - 1)
      if row > 0 {
        scrollToRow(at: IndexPath(row: row - 1, section: section - 1), at: .bottom, animated: animated)
      }
    }
  }
  
  public func showFooterIndicator() {
    let spinner = UIActivityIndicatorView(style: .gray)
    spinner.startAnimating()
    spinner.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 44)
    
    tableFooterView = spinner
    tableFooterView?.isHidden = false
  }
}
