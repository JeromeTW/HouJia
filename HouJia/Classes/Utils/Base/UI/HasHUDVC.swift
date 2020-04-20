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
  var theHUDShowCounter: AtomicInteger { get set }  // 記住 HUD 被請求 show 但是尚未被 hide 的數量
}

extension HasHUDVC {
  public func showHUD() {
    if theHUDShowCounter.value > 0 {
      // 已經顯示了
    } else {
      DispatchQueue.main.async {
        [weak self] in
        guard let innerSelf = self else { return }
        MBProgressHUD.showAdded(to: innerSelf.view, animated: true)
      }
    }
    let temp = theHUDShowCounter.incrementAndGet()
    logT(issue: "theHUDShowCounter", message: "theHUDShowCounter:\(temp)")
  }
  
  public func hideHUD() {
    if theHUDShowCounter.value < 1 {
      // 有問題
      assertionFailure()
    } else if theHUDShowCounter.value == 1 {
      // 最後一個 HUD 請求
      DispatchQueue.main.async {
        [weak self] in
        guard let innerSelf = self else { return }
        MBProgressHUD.hide(for: innerSelf.view, animated: true)
      }
    } else {
      // 還有其他 HUD 請求
    }
    let temp = theHUDShowCounter.decrementAndGet()
    logT(issue: "theHUDShowCounter", message: "theHUDShowCounter:\(temp)")

  }
}


/*
extension HasHUDVC {
  public func showHUD() {
    DispatchQueue.main.async {
      [weak self] in
      guard let strongSelf = self else { return }
      synchronized(strongSelf.theHUDShowCounter) {
        guard let innerSelf = self else { return }
        if innerSelf.theHUDShowCounter.intValue > 0 {
          // 已經顯示了
        } else {
          MBProgressHUD.showAdded(to: innerSelf.view, animated: true)
        }
        innerSelf.theHUDShowCounter = NSNumber(value: innerSelf.theHUDShowCounter.intValue + 1)
        logT(issue: "theHUDShowCounter", message: "theHUDShowCounter:\(innerSelf.theHUDShowCounter.intValue)")
      }
    }
  }
  
  public func hideHUD() {
    DispatchQueue.main.async {
      [weak self] in
      guard let strongSelf = self else { return }
      synchronized(strongSelf.theHUDShowCounter) {
        guard let innerSelf = self else { return }
        if innerSelf.theHUDShowCounter.intValue < 1 {
          // 有問題
          assertionFailure()
        } else if innerSelf.theHUDShowCounter.intValue == 1 {
          // 最後一個 HUD 請求
          MBProgressHUD.hide(for: innerSelf.view, animated: true)
        } else {
          // 還有其他 HUD 請求
        }
        innerSelf.theHUDShowCounter = NSNumber(value: innerSelf.theHUDShowCounter.intValue - 1)
        logT(issue: "theHUDShowCounter", message: "theHUDShowCounter:\(innerSelf.theHUDShowCounter.intValue)")
      }
    }
  }
}
*/
