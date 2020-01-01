//
//  GlobalFunctions.swift
//  HouJia
//
//  Created by JEROME on 2019/12/11.
//

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
