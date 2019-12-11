//
//  URL+.swift
//  GP920_iOS
//
//  Created by Jerome.Hsieh2 on 2018/7/10.
//  Copyright © 2018年 Daniel. All rights reserved.
//

import AVKit
import Foundation

extension URL {
  public var queryParameters: [String: String]? {
    guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true), let queryItems = components.queryItems else {
      return nil
    }

    var parameters = [String: String]()
    for item in queryItems {
      parameters[item.name] = item.value
    }

    return parameters
  }

  public func getFullURL() -> URL {
    var urlString = absoluteString
    if urlString.hasPrefix("http://") || urlString.hasPrefix("https://") {
      return self
    } else {
      urlString = "http://" + urlString
      return URL(string: urlString)!
    }
  }
  
  public func videoSnapshot() -> UIImage? {
    let vidURL = URL(fileURLWithPath: absoluteString)
    let asset = AVURLAsset(url: vidURL)
    let generator = AVAssetImageGenerator(asset: asset)
    generator.appliesPreferredTrackTransform = true
    
    let timestamp = CMTime(seconds: 1, preferredTimescale: 60)
    
    do {
      let imageRef = try generator.copyCGImage(at: timestamp, actualTime: nil)
      return UIImage(cgImage: imageRef)
    }
    catch let error as NSError
    {
      print("Image generation failed with error \(error)")
      return nil
    }
  }
}
