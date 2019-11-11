// String+.swift
// Copyright (c) 2019 Jerome Hsieh. All rights reserved.
// Created by Jerome Hsieh.

import UIKit

extension String {
  public func generateBarcode() -> UIImage? {
    let data = self.data(using: String.Encoding.ascii)

    if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
      filter.setValue(data, forKey: "inputMessage")
      let transform = CGAffineTransform(scaleX: 3, y: 3)

      if let output = filter.outputImage?.transformed(by: transform) {
        return UIImage(ciImage: output)
      }
    }

    return nil
  }
}
