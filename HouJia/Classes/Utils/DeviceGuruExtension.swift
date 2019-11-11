// DeviceGuruExtension.swift
// Copyright (c) 2019 Jerome Hsieh. All rights reserved.
// Created by Jerome Hsieh.

import DeviceGuru
import Foundation

extension DeviceGuru {
  public var hasSensorHousing: Bool {
    let deviceName = hardware()
    let hasSensorHousingDevices: [Hardware] = [.iphone_x, .iphone_xs, .iphone_xs_max, .iphone_xs_max_cn, .iphone_xr]
    return hasSensorHousingDevices.contains(deviceName)
  }
}

extension CGFloat {
  public static var statusAndNavigationTotalHeight: CGFloat {
    let navaigationHeight = CGFloat.navagationViewHeight
    var statusHeight: CGFloat = 0
    if DeviceGuru().hasSensorHousing {
      statusHeight = CGFloat.iPhoneXStatusBarHeight
    } else {
      statusHeight = CGFloat.defaultStatusBarHeight
    }
    return navaigationHeight + statusHeight
  }

  public static var statusHeight: CGFloat {
    if DeviceGuru().hasSensorHousing {
      return CGFloat.iPhoneXStatusBarHeight
    } else {
      return CGFloat.defaultStatusBarHeight
    }
  }
}
