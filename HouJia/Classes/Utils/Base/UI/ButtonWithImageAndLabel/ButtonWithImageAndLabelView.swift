// ButtonWithImageAndLabelView.swift
// Copyright (c) 2019 Jerome Hsieh. All rights reserved.
// Created by Jerome Hsieh.

import UIKit

public class ButtonWithImageAndLabelView: BaseView {
  @IBOutlet public var button: UIButton!
  @IBOutlet public var imageView: UIImageView!
  @IBOutlet public var label: UILabel!
  @IBOutlet public var imageAndLabelHeight: NSLayoutConstraint!
  @IBOutlet weak var imageAndLabelVerticalSpace: NSLayoutConstraint!
}
