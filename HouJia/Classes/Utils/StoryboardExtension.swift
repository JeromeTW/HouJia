// StoryboardExtension.swift
// Copyright (c) 2019 Jerome Hsieh. All rights reserved.
// Created by Jerome Hsieh.

import UIKit

public protocol Storyboarded {
  static func instantiate(storyboard: UIStoryboard) -> Self
}

extension Storyboarded where Self: UIViewController {
  public static func instantiate(storyboard: UIStoryboard) -> Self {
    // this pulls out "MyApp.MyViewController"
    let fullName = NSStringFromClass(self)

    // this splits by the dot and uses everything after, giving "MyViewController"
    let className = fullName.components(separatedBy: ".")[1]

    // instantiate a view controller with that identifier, and force cast as the type that was requested
    return storyboard.instantiateViewController(withIdentifier: className) as! Self
  }
}
