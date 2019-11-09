// LogTextView.swift
// Copyright (c) 2019 Jerome Hsieh. All rights reserved.
// Created by Jerome Hsieh.

/// NOTE: Work with CGFloatExtension.swift file.
import UIKit

public class LogTextView: UITextView {
  override public init(frame: CGRect, textContainer: NSTextContainer?) {
    super.init(frame: frame, textContainer: textContainer)
    layer.zPosition = .greatestFiniteMagnitude
    setupStyle()
  }

  required public init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override public func hitTest(_: CGPoint, with _: UIEvent?) -> UIView? {
    return nil
  }

  private func setupStyle() {
    backgroundColor = .white
    alpha = 0.7
    textColor = .black
  }
}

extension UIView {
  public typealias Constraint = (_ subview: UIView, _ superview: UIView) -> NSLayoutConstraint

  public func addSubview(_ subview: UIView, constraints: [Constraint]) {
    addSubview(subview)
    subview.translatesAutoresizingMaskIntoConstraints = false
    addConstraints(constraints.map { $0(subview, self) })
  }

  public func insertSubview(_ subview: UIView, at: Int, constraints: [Constraint]) {
    insertSubview(subview, at: at)
    subview.translatesAutoresizingMaskIntoConstraints = false
    addConstraints(constraints.map { $0(subview, self) })
  }

  /// ex: subview.topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: constant)
  /// - Parameter subviewKeyPath: subview's KeyPath
  /// - Parameter superviewKeyPath: superview's KeyPath
  /// - Parameter constant: anchors distance constant
  public static func anchorConstraintEqual<LayoutAnchor, Axis>(from subviewKeyPath: KeyPath<UIView, LayoutAnchor>,
                                                        to superviewKeyPath: KeyPath<UIView, LayoutAnchor>,
                                                        constant: CGFloat = 0.0) -> Constraint where LayoutAnchor: NSLayoutAnchor<Axis> {
    return { subview, superview in
      subview[keyPath: subviewKeyPath]
        .constraint(equalTo: superview[keyPath: superviewKeyPath],
                    constant: constant)
    }
  }

  /// ex: subview.topAnchor.constraint(equalTo: superview.topAnchor, constant: constant)
  /// - Parameter viewKeyPath: subview's and superview's KeyPath
  /// - Parameter constant: anchors distance constant
  public static func anchorConstraintEqual<LayoutAnchor, Axis>(with viewKeyPath: KeyPath<UIView, LayoutAnchor>,
                                                        constant: CGFloat = 0.0) -> Constraint where LayoutAnchor: NSLayoutAnchor<Axis> {
    return anchorConstraintEqual(from: viewKeyPath,
                                 to: viewKeyPath,
                                 constant: constant)
  }
}
