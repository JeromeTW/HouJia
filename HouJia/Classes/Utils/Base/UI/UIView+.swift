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

// MARK: - CGAffineTransform
extension UIView {
  public func scale(_ scale: CGFloat) {
    transform = CGAffineTransform(scaleX: scale, y: scale)
  }
  
  /// Helper to get pre transform frame
  public var originalFrame: CGRect {
    let currentTransform = transform
    transform = .identity
    let originalFrame = frame
    transform = currentTransform
    return originalFrame
  }
  
  /// Helper to get point offset from center
  public func centerOffset(_ point: CGPoint) -> CGPoint {
    return CGPoint(x: point.x - center.x, y: point.y - center.y)
  }
  
  /// Helper to get point back relative to center
  public func pointRelativeToCenter(_ point: CGPoint) -> CGPoint {
    return CGPoint(x: point.x + center.x, y: point.y + center.y)
  }
  
  /// Helper to get point relative to transformed coords
  public func newPointInView(_ point: CGPoint) -> CGPoint {
    // get offset from center
    let offset = centerOffset(point)
    // get transformed point
    let transformedPoint = offset.applying(transform)
    // make relative to center
    return pointRelativeToCenter(transformedPoint)
  }
  
  public var newTopLeft: CGPoint {
    return newPointInView(originalFrame.origin)
  }
  
  public var newTopRight: CGPoint {
    var point = originalFrame.origin
    point.x += originalFrame.width
    return newPointInView(point)
  }
  
  public var newBottomLeft: CGPoint {
    var point = originalFrame.origin
    point.y += originalFrame.height
    return newPointInView(point)
  }
  
  public var newBottomRight: CGPoint {
    var point = originalFrame.origin
    point.x += originalFrame.width
    point.y += originalFrame.height
    return newPointInView(point)
  }
  
  public var newWidth: CGFloat {
    return newTopRight.x - newTopLeft.x
  }
  
  public var newHeight: CGFloat {
    return newBottomLeft.y - newTopLeft.y
  }
}

