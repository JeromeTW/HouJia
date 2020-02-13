//
//  Data+.swift
//  HouJia
//
//  Created by JEROME on 2020/2/13.
//

import Foundation

extension Data {
  public func logSize() {
    let bcf = ByteCountFormatter()
    bcf.allowedUnits = [.useMB] // optional: restricts the units to MB only
    bcf.countStyle = .file
    let string = bcf.string(fromByteCount: Int64(count))
    logT(issue: "Data Size", message: "There were \(count) bytes")
    logT(issue: "Data Size", message: "formatted result: \(string)")
  }
}
