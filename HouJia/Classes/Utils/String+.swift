// String+.swift
// Copyright (c) 2019 Jerome Hsieh. All rights reserved.
// Created by Jerome Hsieh.

import UIKit

extension String {
  /// Assuming the current string is base64 encoded, this property returns a String
  /// initialized by converting the current string into Unicode characters, encoded to
  /// utf8. If the current string is not base64 encoded, nil is returned instead.
  public var base64Decoded: String? {
    guard let base64 = Data(base64Encoded: self) else { return nil }
    let utf8 = String(data: base64, encoding: .utf8)
    return utf8
  }
  
  /// Returns a base64 representation of the current string, or nil if the
  /// operation fails.
  public var base64Encoded: String? {
    let utf8 = self.data(using: .utf8)
    let base64 = utf8?.base64EncodedString()
    return base64
  }
  
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
  
  public var isLettersOnly: Bool {
    let characterSet = CharacterSet.letters
    if rangeOfCharacter(from: characterSet.inverted) != nil {
        return false
    } else {
      return true
    }
  }
  
  public var isAlphaNumeric: Bool {
    let alphaNumericSet = CharacterSet.alphanumerics
    if rangeOfCharacter(from: alphaNumericSet.inverted) != nil {
        return false
    } else {
      return true
    }
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
