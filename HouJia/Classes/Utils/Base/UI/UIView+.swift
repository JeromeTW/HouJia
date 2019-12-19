//
//  UIView+.swift
//  HouJia
//
//  Created by JEROME on 2019/11/26.
//

import UIKit

extension UIView {
  
  // MARK: - 搜尋父層或子層 view 的類型
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
  
  public func superviewOfType<T: UIView>(type: T.Type) -> T? {
    if let view = self as? T {
      return view
    } else if let tempSuperview = superview {
      return tempSuperview.superviewOfType(type: T.self)
    } else {
      return nil
    }
  }
  
  // MARK: - 中間透明的 View
  public convenience init(frame: CGRect, centerTransparentRectFrame: CGRect, alpha: CGFloat) {
    self.init(frame: frame)
    backgroundColor = UIColor.black.withAlphaComponent(alpha)
    let path = CGMutablePath()
    path.addRect(centerTransparentRectFrame)
    path.addRect(CGRect(origin: .zero, size: frame.size))
    let maskLayer = CAShapeLayer()
    maskLayer.backgroundColor = UIColor.black.cgColor
    maskLayer.path = path
    maskLayer.fillRule = .evenOdd
    layer.mask = maskLayer
    clipsToBounds = true
  }
  
  public convenience init(frame: CGRect, centerTransparentCirclePoint: CGPoint, radius: CGFloat, alpha: CGFloat) {
    self.init(frame: frame)
    backgroundColor = UIColor.black.withAlphaComponent(alpha)
    let path = CGMutablePath()
    path.addArc(center: centerTransparentCirclePoint, radius: radius, startAngle: 0.0, endAngle: 2.0 * .pi, clockwise: false)
    path.addRect(CGRect(origin: .zero, size: frame.size))
    let maskLayer = CAShapeLayer()
    maskLayer.backgroundColor = UIColor.black.cgColor
    maskLayer.path = path
    maskLayer.fillRule = .evenOdd
    layer.mask = maskLayer
    clipsToBounds = true
  }
}


