// Coordinator.swift
// Copyright (c) 2019 Jerome Hsieh. All rights reserved.
// Created by Jerome Hsieh.

import UIKit

public protocol Coordinator: AnyObject {
  var navigationController: CoordinatedNavigationController { get set }
}
