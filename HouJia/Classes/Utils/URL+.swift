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
  public func getFullURL() -> URL {
    var urlString = absoluteString
    if urlString.hasPrefix("http://") || urlString.hasPrefix("https://") {
      return self
    } else {
      urlString = "http://" + urlString
      return URL(string: urlString)!
    }
  }
  
  public func generateVideoThumbnail() -> UIImage? {
    do {
      let asset = AVURLAsset(url: self, options: nil)
      let imgGenerator = AVAssetImageGenerator(asset: asset)
      imgGenerator.appliesPreferredTrackTransform = true
      let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
      let thumbnail = UIImage(cgImage: cgImage)
      return thumbnail
    } catch let error {
      logE(error)
      return nil
    }
  }
  
  public func getAudioDuration() -> Double? {
    do {
      let audioPlayer = try AVAudioPlayer(contentsOf: self)
      return audioPlayer.duration
    } catch {
      logE(error)
      assertionFailure("Failed crating audio player: \(error).")
      return nil
    }
  }
  
  public func add(parameters: [AnyHashable: Any]) -> URL? {
    var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false)
    let queryItems = parameters.map{
        return URLQueryItem(name: "\($0)", value: "\($1)")
    }

    urlComponents?.queryItems = queryItems
    return urlComponents?.url
  }
}
