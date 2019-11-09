// ExampleMainTabBarController.swift
// Copyright (c) 2019 Jerome Hsieh. All rights reserved.
// Created by Jerome Hsieh.

import UIKit

class ExampleMainTabBarController: UITabBarController {
  let example = ExampleCoordinator()
  let tabBarItemInfos: [UITabBarItemInfo] = [UITabBarItemInfo(title: "List", image: nil, selectedImage: nil)]

  // 呼叫順序 T -> TabBarController; N -> NacigationController; V -> ViewController
  // ViewDidLoad -> ViewDidAppeard
  // T N V    -> T N V
  override func viewDidLoad() {
    super.viewDidLoad()
    viewControllers = [example.navigationController]
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    guard let items = tabBar.items else {
      fatalError()
    }
    assert(tabBarItemInfos.count == items.count)
    for (index, item) in items.enumerated() {
      item.title = tabBarItemInfos[index].title
      item.image = tabBarItemInfos[index].image
      item.selectedImage = tabBarItemInfos[index].selectedImage
    }
  }
}
