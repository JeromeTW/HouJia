//
//  UIImage.swift
//  GP920_iOS
//
//  Created by Howard on 2016/7/7.
//  Copyright © 2016年 Daniel. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
  public func resizeByLongestSide(length: CGFloat) -> UIImage {
    let width = size.width
    let height = size.height
    let scale = width / height
    
    var sizeChange: CGSize!
    
    if width <= length && height <= length {
      return self
    } else {
      if width >= height {
        let changedWidth = length
        let changedheight = changedWidth / scale
        sizeChange = CGSize(width: changedWidth, height: changedheight)
      } else {
        let changedheight = length
        let changedWidth = changedheight * scale
        sizeChange = CGSize(width: changedWidth, height: changedheight)
      }
      logT(issue: "sizeChange", message: "sizeChange:\(sizeChange)")
      UIGraphicsBeginImageContext(sizeChange)

      // draw resized image on Context
      draw(in: CGRect(x: 0, y: 0, width: sizeChange.width, height: sizeChange.height))

      // create UIImage
      let resizedImg = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()

      return resizedImg!
    }
  }
  
  public func resize(_ size: CGSize) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(size, false, 3.0)
    draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return newImage
  }

  public func resizeForSquare(_ side: CGFloat) -> UIImage? {
    var scale: CGFloat!
    if self.size.height > self.size.width {
      scale = side / self.size.width
    } else {
      scale = side / self.size.height
    }
    let newHeight = self.size.height * scale
    let newWidth = self.size.width * scale
    let size = CGSize(width: newWidth, height: newHeight)
    UIGraphicsBeginImageContextWithOptions(size, false, 3.0)
    draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage
  }

  public func scaleBasedOnSmallRadioEdges(_ newSize: CGSize) -> UIImage? {
    var scale: CGFloat!
    
    let heightScale = newSize.height / self.size.height
    let widthScale = newSize.width / self.size.width
    scale = min(heightScale, widthScale)
    let newHeight = self.size.height * scale
    let newWidth = self.size.width * scale
    let size = CGSize(width: newWidth, height: newHeight)

    return resize(size)
  }

  public func compressPhoto() -> Data! {
    func resizeCompress(originalImg: UIImage) -> UIImage {
      let width = originalImg.size.width
      let height = originalImg.size.height
      let scale = width / height

      var sizeChange = CGSize()

      if width <= 1280 && height <= 1280 {
        // 寬跟高都小於等於1280保持尺寸不變，不改變圖片大小
        return originalImg
      } else if width > 1280 || height > 1280 {
        // 寬或高大於1280，但是圖片寬高比小於等於2，將圖片寬高取大者壓縮至1280
        if scale <= 2 && scale >= 1 {
          let changedWidth: CGFloat = 1280
          let changedheight: CGFloat = changedWidth / scale
          sizeChange = CGSize(width: changedWidth, height: changedheight)
        } else if scale >= 0.5 && scale <= 1 {
          let changedheight: CGFloat = 1280
          let changedWidth: CGFloat = changedheight * scale
          sizeChange = CGSize(width: changedWidth, height: changedheight)
        } else if width > 1280 && height > 1280 {
          // 寬跟高皆大於1280，但是圖片寬高比大於2，將圖片寬高取小者壓縮至1280
          if scale > 2 {
            // 高的比值小
            let changedheight: CGFloat = 1280
            let changedWidth: CGFloat = changedheight * scale
            sizeChange = CGSize(width: changedWidth, height: changedheight)
          } else if scale < 0.5 {
            // 寬的比值小
            let changedWidth: CGFloat = 1280
            let changedheight: CGFloat = changedWidth / scale
            sizeChange = CGSize(width: changedWidth, height: changedheight)
          }
        } else {
          // 寬或高只有一個大於1280，且寬高比超過2，不改變圖片大小
          return originalImg
        }
      }

      UIGraphicsBeginImageContext(sizeChange)

      // draw resized image on Context
      draw(in: CGRect(x: 0, y: 0, width: sizeChange.width, height: sizeChange.height))

      // create UIImage
      let resizedImg = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()

      return resizedImg!
    }

    let resizedImage = resizeCompress(originalImg: self)
    var zipImageData = resizedImage.jpegData(compressionQuality: 1)!
    let resizedImageSize = zipImageData.count

    if resizedImageSize > 1500 {

      zipImageData = resizedImage.jpegData(compressionQuality: 0.1)!
    } else if resizedImageSize > 600 {
      zipImageData = resizedImage.jpegData(compressionQuality: 0.2)!
    } else if resizedImageSize > 400 {
      zipImageData = resizedImage.jpegData(compressionQuality: 0.3)!
    } else if resizedImageSize > 300 {
      zipImageData = resizedImage.jpegData(compressionQuality: 0.4)!
    } else if resizedImageSize > 200 {
      zipImageData = resizedImage.jpegData(compressionQuality: 0.5)!
    }

    return zipImageData
  }

  public func fixOrientation() -> UIImage {
    if imageOrientation == .up {
      return self
    }

    var transform = CGAffineTransform.identity

    switch imageOrientation {
    case .down, .downMirrored:
      transform = transform.translatedBy(x: size.width, y: size.height)
      transform = transform.rotated(by: CGFloat.pi)

    case .left, .leftMirrored:
      transform = transform.translatedBy(x: size.width, y: 0)
      transform = transform.rotated(by: CGFloat(Double.pi / 2))

    case .right, .rightMirrored:
      transform = transform.translatedBy(x: 0, y: size.height)
      transform = transform.rotated(by: CGFloat(-Double.pi / 2))

    default:
      break
    }

    switch imageOrientation {
    case .upMirrored, .downMirrored:
      transform = transform.translatedBy(x: size.width, y: 0)
      transform = transform.scaledBy(x: -1, y: 1)

    case .leftMirrored, .rightMirrored:
      transform = transform.translatedBy(x: size.height, y: 0)
      transform = transform.scaledBy(x: -1, y: 1)

    default:
      break
    }

    // 如果 bitmapInfo == 0，表示 cgImage 不是點陣圖，return ctx == nil.
    guard let ctx = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height),
                              bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0,
                              space: self.cgImage!.colorSpace!,
                              bitmapInfo: self.cgImage!.bitmapInfo.rawValue) else {
      return self
    }
    ctx.concatenate(transform)

    switch imageOrientation {
    case .left, .leftMirrored, .right, .rightMirrored:
      ctx.draw(cgImage!, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
    default:
      ctx.draw(cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
    }

    // And now we just create a new UIImage from the drawing context
    let cgimg = ctx.makeImage()
    return UIImage(cgImage: cgimg!)
  }

  public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
    let rect = CGRect(origin: .zero, size: size)
    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
    color.setFill()
    UIRectFill(rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    guard let cgImage = image?.cgImage else { return nil }
    self.init(cgImage: cgImage)
  }

  public enum JPEGQuality: CGFloat {
    case lowest  = 0
    case low     = 0.25
    case medium  = 0.5
    case high    = 0.75
    case highest = 1
  }

  /// Returns the data for the specified image in JPEG format.
  /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
  /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
  public func jpeg(_ quality: JPEGQuality) -> Data? {
    return self.jpegData(compressionQuality: quality.rawValue)
  }
}
