//
//  ViewController.swift
//  HouJia
//
//  Created by jerome.developer.tw@gmail.com on 11/09/2019.
//  Copyright (c) 2019 jerome.developer.tw@gmail.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

