// BaseView.swift
// Copyright (c) 2019 Jerome Hsieh. All rights reserved.
// Created by Jerome Hsieh.

import UIKit

// Brunch dev, 2
open class BaseView: UIView {
  required public init?(coder: NSCoder) {
    logC("init?(coder: NSCoder)")
    super.init(coder: coder)
  }

  override public init(frame: CGRect) {
    logC("init(frame: NSCoder)")
    super.init(frame: frame)
  }

  override open func awakeFromNib() {
    logC("awakeFromNib")
    super.awakeFromNib()
  }

  override open func willMove(toWindow newWindow: UIWindow?) {
    logC("willMove(toWindow newWindow: UIWindow?)")
    super.willMove(toWindow: newWindow)
  }

  override open func didMoveToWindow() {
    logC("didMoveToWindow")
    super.didMoveToWindow()
  }

  override open func willMove(toSuperview newSuperview: UIView?) {
    logC("willMove(toSuperview newSuperview: UIView?)")
    super.willMove(toSuperview: newSuperview)
  }

  override open func didMoveToSuperview() {
    logC("didMoveToSuperview")
    super.didMoveToSuperview()
  }

  override open func didAddSubview(_ subview: UIView) {
    logC("didAddSubview(_ subview: UIView)")
    super.didAddSubview(subview)
  }

  override open func willRemoveSubview(_ subview: UIView) {
    logC("willRemoveSubview")
    super.willRemoveSubview(subview)
  }

  override open func layoutSubviews() {
    logC("layoutSubviews")
    super.layoutSubviews()
  }

  #if DEBUG
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override open func draw(_ rect: CGRect) {
      logC("draw(_ rect: CGRect)")
      super.draw(rect)
    }
  #endif
}
