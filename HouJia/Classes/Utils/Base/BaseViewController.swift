// BaseViewController.swift
// Copyright (c) 2019 Jerome Hsieh. All rights reserved.
// Created by Jerome Hsieh.

import UIKit

public class BaseViewController: UIViewController {
  // MARK: - ViewController lifecycle

  deinit {
    logC("\(self.className) deinit")
  }

  override public func loadView() {
    logC("\(className) loadView")
    let vc = UIViewController()
    print(vc.className) // UIViewController
    print(UIViewController.className) // UIViewController
    super.loadView()
  }

  override public func viewDidLoad() {
    logC("\(className) viewDidLoad")
    super.viewDidLoad()
  }

  override public func viewWillAppear(_ animated: Bool) {
    logC("\(className) viewWillAppear:")
    super.viewWillAppear(animated)
  }

  override public func viewDidAppear(_ animated: Bool) {
    logC("\(className) viewDidAppear:")
    super.viewDidAppear(animated)
  }

  override public func viewWillLayoutSubviews() {
    logC("\(className) viewWillLayoutSubviews")
    super.viewWillLayoutSubviews()
  }

  override public func viewDidLayoutSubviews() {
    logC("\(className) viewDidLayoutSubviews")
    super.viewDidLayoutSubviews()
  }

  override public func viewWillDisappear(_ animated: Bool) {
    logC("\(className) viewWillDisappear:")
    super.viewWillDisappear(animated)
  }

  override public func viewDidDisappear(_ animated: Bool) {
    logC("\(className) viewDidDisappear:")
    super.viewDidDisappear(animated)
  }

  override public func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    logC("\(className) viewWillTransition:")
    super.viewWillTransition(to: size, with: coordinator)
  }

  // MARK: - Inherit method

  override public func touchesBegan(_: Set<UITouch>, with _: UIEvent?) {
    view.endEditing(true)
  }
}
