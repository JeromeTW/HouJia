// CoordinatedNavigationController.swift
// Copyright (c) 2019 Jerome Hsieh. All rights reserved.
// Created by Jerome Hsieh.

import UIKit

/// A navigation controller that is aware of its coordinator. This is used extremely rarely through UIResponder-Coordinated.swift, for when we need to find the coordinator responsible for a specific view.
public class CoordinatedNavigationController: UINavigationController, UIGestureRecognizerDelegate {
  public weak var coordinator: Coordinator?
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    interactivePopGestureRecognizer?.delegate = self
  }
  
  public override func pushViewController(_ viewController: UIViewController, animated: Bool) {
    super.pushViewController(viewController, animated: animated)
    interactivePopGestureRecognizer?.isEnabled = false
  }
}
