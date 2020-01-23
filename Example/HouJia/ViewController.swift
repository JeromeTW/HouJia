//
//  ViewController.swift
//  HouJia
//
//  Created by jerome.developer.tw@gmail.com on 11/09/2019.
//  Copyright (c) 2019 jerome.developer.tw@gmail.com. All rights reserved.
//

import UIKit

class ViewController: BaseViewController {

  @IBOutlet var tableView: UITableView! {
    didSet {
      tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
      tableView.contentInsetAdjustmentBehavior = .never
      tableView.estimatedRowHeight = 220.f
//      tableView.showFooterIndicator() // 小灰
//      tableView.showFooterIndicator(style: .white, color: .orange, scale: 1)  // 小橘
//      tableView.showFooterIndicator(style: .white, color: .orange, scale: 5)  // 不會出界的大橘
      tableView.showFooterIndicator(style: .white, color: .orange, scale: 5, paddingY: 20)  // 會出界的大橘往下偏移 20
    }
  }
  
  @IBOutlet weak var buttonWithImageAndLabelSuperView: ButtonWithImageAndLabelSuperView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
      buttonWithImageAndLabelSuperView.buttonWithImageAndLabelView.badgeViewWidth.constant = 30
    }

  var isFirst = true
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    guard isFirst else {
      return
    }
    isFirst = false
    buttonWithImageAndLabelSuperView.image = UIImage(named: "gift")
    let badgeView = buttonWithImageAndLabelSuperView.buttonWithImageAndLabelView.badgeView!
    badgeView.backgroundColor = .green
    badgeView.layer.cornerRadius = 30 / 2.0
    let badgeLabel = buttonWithImageAndLabelSuperView.buttonWithImageAndLabelView.badgeLabel!
    badgeLabel.text = "99+"
    badgeLabel.font = UIFont.boldSystemFont(ofSize: 12)
    badgeLabel.tintColor = .white
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    logC("isViewDidLoad:\(isViewDidLoad)")
//    showAlertController(withTitle: "Title", message: "message", textFieldsData: [UIViewController.TextFieldData(text: nil, placeholder: nil)], leftTitle: "Left", leftHandler: nil, rightTitle: "Right") { textfields in
//      print("Right")
//    }
  }
}

