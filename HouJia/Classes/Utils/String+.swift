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
  
  public func insert(_ string: String, index: Int) -> String {
    var copyString = self
    let tempIndex = copyString.index(copyString.startIndex, offsetBy: index)
    copyString.insert(contentsOf: string, at: tempIndex)
    return copyString
  }
}

// MARK: - Regex
extension String {
  public func checkRegex(with pattern: String) -> Bool {
    do {
      let regex = try NSRegularExpression(pattern: pattern)
      let results = regex.matches(in: self,
                                  range: NSRange(self.startIndex..., in: self))
      print("results:\(results.count)")
      return results.count == 1
    } catch let error {
      print("invalid regex: \(error.localizedDescription)")
      return false
    }
  }
}
