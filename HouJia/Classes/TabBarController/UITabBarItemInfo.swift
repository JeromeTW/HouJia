// UITabBarItemInfo.swift
// Copyright (c) 2019 Jerome Hsieh. All rights reserved.
// Created by Jerome Hsieh.

import UIKit

public struct UITabBarItemInfo {
  public var title: String?
  public var image: UIImage?
  public var selectedImage: UIImage?
  
  public init(title: String?, image: UIImage?, selectedImage: UIImage?) {
      self.title = title
      self.image = image
      self.selectedImage = selectedImage
  }
}
