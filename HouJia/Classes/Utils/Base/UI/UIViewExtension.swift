//
//  UIViewExtension.swift
//  GP920_iOS
//
//  Created by Jerome.Hsieh2 on 2019/6/12.
//  Copyright © 2019 Daniel. All rights reserved.
//

import UIKit

extension UIView {
  public func rotate360Degrees(isClockwise: Bool, duration: CFTimeInterval = 3) {
    let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
    rotateAnimation.fromValue = 0.0
    if isClockwise {
      rotateAnimation.toValue = CGFloat(Double.pi * 2)
    } else {
      rotateAnimation.toValue = CGFloat(Double.pi * -2)
    }
    rotateAnimation.isRemovedOnCompletion = false
    rotateAnimation.duration = duration
    rotateAnimation.repeatCount = Float.infinity
    self.layer.add(rotateAnimation, forKey: nil)
  }
}
