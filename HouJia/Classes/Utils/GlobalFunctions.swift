//
//  GlobalFunctions.swift
//  HouJia
//
//  Created by JEROME on 2019/12/11.
//

import AVKit
import Foundation

public func assertNotNil(_ items: Optional<Any>...) {
  for item in items {
    assert(item != nil)
  }
}

public func getDocumentsDirectory() -> URL {
  let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
  let documentsDirectory = paths.first
  return documentsDirectory!
}

public func getTemporaryDirectory() -> URL {
  return URL(fileURLWithPath: NSTemporaryDirectory())
}

public func generateBoundaryString() -> String {
  return "Boundary-\(UUID().uuidString)"
}

public struct PostFileInfo {
  var filePathKey: String
  var fileName: String
  var data: Data
  var dataType: String
  
  public init(filePathKey: String, fileName: String, data: Data, dataType: String) {
    self.filePathKey = filePathKey
    self.fileName = fileName
    self.data = data
    self.dataType = dataType
  }
}

public func createBodyWithParameters(_ parameters: [String: String]?, postFileInfo: PostFileInfo?, boundary: String) -> Data {
  let body = NSMutableData()

  if let parameters = parameters {
    for (key, value) in parameters {
      body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
      body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
      body.append("\(value)\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
    }
  }

  if let postFileInfo = postFileInfo {
    body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
    body.append("Content-Disposition: form-data; name=\"\(postFileInfo.filePathKey)\"; filename=\"\(postFileInfo.fileName)\"\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
    body.append("Content-Type: \(postFileInfo.dataType)\r\n\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
    body.append(postFileInfo.data)
    body.append("\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
  }

  body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8, allowLossyConversion: true)!)
  return body as Data
}

public func encodeVideoToMP4(videoUrl: URL, outputUrl: URL? = nil, resultAsyncBackgroundThreadHandler: @escaping (URL?) -> Void ) {
  
  var finalOutputUrl: URL? = outputUrl
  
  if finalOutputUrl == nil {
    var url = videoUrl
    url.deletePathExtension()
    url.appendPathExtension(".mp4")
    finalOutputUrl = url
  }
  
  if FileManager.default.fileExists(atPath: finalOutputUrl!.path) {
    print("Converted file already exists \(finalOutputUrl!.path)")
    resultAsyncBackgroundThreadHandler(finalOutputUrl)
    return
  }
  
  let asset = AVURLAsset(url: videoUrl)
  if let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetPassthrough) {
    exportSession.outputURL = finalOutputUrl!
    exportSession.outputFileType = AVFileType.mp4
    let start = CMTimeMakeWithSeconds(0.0, preferredTimescale: 0)
    let range = CMTimeRangeMake(start: start, duration: asset.duration)
    exportSession.timeRange = range
    exportSession.shouldOptimizeForNetworkUse = true
    exportSession.exportAsynchronously() {
      
      switch exportSession.status {
      case .failed:
        print("Export failed: \(exportSession.error != nil ? exportSession.error!.localizedDescription : "No Error Info")")
      case .cancelled:
        print("Export canceled")
      case .completed:
        resultAsyncBackgroundThreadHandler(finalOutputUrl!)
      default:
        break
      }
    }
  } else {
    resultAsyncBackgroundThreadHandler(nil)
  }
}

public func setViews(isHidden hidden: Bool, _ views: UIView...) {
  for view in views {
    view.isHidden = hidden
  }
}

public func setControls(isEnable enable: Bool, _ controls: UIControl...) {
  for control in controls {
    control.isEnabled = enable
  }
}

public func createNotification() {
  
  let content = UNMutableNotificationContent()
  content.title = "我是標題 title"
  content.subtitle = "我是子標題 subtitle"
  content.body = "我是 Body我是 Body我是 Body我是 Body我是 Body我是 Body我是 Body我是 Body我是 Body我是 Body我是 Body我是 Body我是 Body我是 Body我是 Body我是 Body我是 Body"
  content.badge = 1
  content.sound = UNNotificationSound.default
  
  let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
  let request = UNNotificationRequest(identifier: "notification1", content: content, trigger: trigger)
  UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
}
