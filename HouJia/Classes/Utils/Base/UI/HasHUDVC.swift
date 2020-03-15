//
//  HasHUDVC.swift
//  CMP_System
//
//  Created by JEROME on 2020/1/29.
//  Copyright © 2020 jerome. All rights reserved.
//

import Foundation
import MBProgressHUD

public protocol HasHUDVC: UIViewController {
  var theHUDShowCounter: NSNumber { get set }  // 記住 HUD 被請求 show 但是尚未被 hide 的數量
}

extension HasHUDVC {
  func showHUD() {
    DispatchQueue.main.async {
      [weak self] in
      guard let strongSelf = self else { return }
      if strongSelf.theHUDShowCounter.intValue > 0 {
        // 已經顯示了
        
      } else {
        MBProgressHUD.showAdded(to: strongSelf.view, animated: true)
      }
      synchronized(strongSelf.theHUDShowCounter) {
        guard let innerSelf = self else { return }
        strongSelf.theHUDShowCounter = NSNumber(value: strongSelf.theHUDShowCounter.intValue + 1)
        logT(issue: "theHUDShowCounter", message: "theHUDShowCounter:\(strongSelf.theHUDShowCounter.intValue)")
      }
    }
  }
  
  func hideHUD() {
    DispatchQueue.main.async {
      [weak self] in
      guard let strongSelf = self else { return }
      if strongSelf.theHUDShowCounter.intValue < 1 {
        // 有問題
        assertionFailure()
      } else if strongSelf.theHUDShowCounter.intValue == 1 {
        // 最後一個 HUD 請求
        MBProgressHUD.hide(for: strongSelf.view, animated: true)
      } else {
        // 還有其他 HUD 請求
      }
      synchronized(strongSelf.theHUDShowCounter) {
        guard let innerSelf = self else { return }
        strongSelf.theHUDShowCounter = NSNumber(value: strongSelf.theHUDShowCounter.intValue - 1)
        logT(issue: "theHUDShowCounter", message: "theHUDShowCounter:\(strongSelf.theHUDShowCounter.intValue)")
      }
    }
  }
}
