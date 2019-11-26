// Coordinator.swift
// Copyright (c) 2019 Jerome Hsieh. All rights reserved.
// Created by Jerome Hsieh.

import UIKit

public protocol Coordinator: AnyObject {
  var navigationController: CoordinatedNavigationController { get set }
  var parentCoordinator: Coordinator? { get set }
  var childCoordinators: [Coordinator] { get set }
  func childDidFinish(_ child: Coordinator?)
}

// MARK: - Parent Coordinator
extension Coordinator {
  public func childDidFinish(_ child: Coordinator?) {
    for (index, coordinator) in childCoordinators.enumerated() {
      if coordinator === child {
        childCoordinators.remove(at: index)
        break
      }
    }
  }
}
