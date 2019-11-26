// ExampleCoordinator.swift
// Copyright (c) 2019 Jerome Hsieh. All rights reserved.
// Created by Jerome Hsieh.

import UIKit

class ExampleCoordinator: Coordinator {
  var navigationController: CoordinatedNavigationController
  // TODO: use your storyboard
  let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
  weak var parentCoordinator: Coordinator?
  var childCoordinators = [Coordinator]()

  init(navigationController: CoordinatedNavigationController = CoordinatedNavigationController()) {
    self.navigationController = navigationController
    navigationController.navigationBar.prefersLargeTitles = true
    navigationController.coordinator = self

    // TODO: Need Implentation
//    let categoryListVC = CategoryListVC.instantiate(storyboard: storyboard)
//    categoryListVC.ExampleCoordinator = self
//    navigationController.navigationBar.isHidden = true
//    navigationController.viewControllers = [categoryListVC]
  }

  // Use Coordinator change page sample.
//  func videoCategoryDetail(category: VideoCategory) {
//    let categoryDetailVC = CategoryDetailVC.instantiate(storyboard: storyboard)
//    categoryDetailVC.category = category
//    categoryDetailVC.ExampleCoordinator = self
//    navigationController.pushViewController(categoryDetailVC, animated: true)
//  }
}
