//
//  UITableView.swift
//  GP920_iOS
//
//  Created by Howard on 2016/8/3.
//  Copyright © 2016年 Daniel. All rights reserved.
//

import UIKit

extension UITableView {
  public func scrollToBottom(animated: Bool = true, at: ScrollPosition) {
    let section = numberOfSections
    if section > 0 {
      let row = numberOfRows(inSection: section - 1)
      if row > 0 {
        scrollToRow(at: IndexPath(row: row - 1, section: section - 1), at: at, animated: animated)
      }
    }
  }
  
  public func showFooterIndicator(style: UIActivityIndicatorView.Style = .gray, color: UIColor? = nil, scale: CGFloat = 1, paddingY: CGFloat = 0) {
    let spinner = UIActivityIndicatorView(style: .gray)
    if let color = color {
      spinner.color = color
    }
    spinner.scale(scale)
    spinner.startAnimating()
    spinner.frame = CGRect(x: 0, y: paddingY, width: bounds.width, height: spinner.newHeight + paddingY * 2)
    print("spinner.newHeight:\(spinner.newHeight), spinner.newWidth:\(spinner.newWidth)")
    
    tableFooterView = spinner
    tableFooterView?.isHidden = false
  }
}
