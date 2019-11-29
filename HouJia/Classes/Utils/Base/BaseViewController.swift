// BaseViewController.swift
// Copyright (c) 2019 Jerome Hsieh. All rights reserved.
// Created by Jerome Hsieh.

import UIKit

open class BaseViewController: UIViewController {
  // MARK: - ViewController lifecycle

  deinit {
    logC("\(self.className) deinit")
  }

  override open func loadView() {
    logC("\(className) loadView")
    super.loadView()
  }

  override open func viewDidLoad() {
    logC("\(className) viewDidLoad")
    super.viewDidLoad()
  }

  override open func viewWillAppear(_ animated: Bool) {
    logC("\(className) viewWillAppear:")
    super.viewWillAppear(animated)
  }

  override open func viewDidAppear(_ animated: Bool) {
    logC("\(className) viewDidAppear:")
    super.viewDidAppear(animated)
  }

  override open func viewWillLayoutSubviews() {
    logC("\(className) viewWillLayoutSubviews")
    super.viewWillLayoutSubviews()
  }

  override open func viewDidLayoutSubviews() {
    logC("\(className) viewDidLayoutSubviews")
    super.viewDidLayoutSubviews()
  }

  override open func viewWillDisappear(_ animated: Bool) {
    logC("\(className) viewWillDisappear:")
    super.viewWillDisappear(animated)
  }

  override open func viewDidDisappear(_ animated: Bool) {
    logC("\(className) viewDidDisappear:")
    super.viewDidDisappear(animated)
  }

  override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    logC("\(className) viewWillTransition:")
    super.viewWillTransition(to: size, with: coordinator)
  }

  // MARK: - Inherit method

  override open func touchesBegan(_: Set<UITouch>, with _: UIEvent?) {
    view.endEditing(true)
  }
}
