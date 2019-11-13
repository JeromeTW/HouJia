//
//  Flexible.swift
//  HouJia
//
//  Created by JEROME on 2019/11/13.
//

import Foundation

public class IntFlexible: NSObject, Decodable {
  
  public var value: Int
  
  public init(_ value: Int) {
    self.value = value
  }
  
  /// Creates a new instance by decoding from the given decoder.
  ///
  /// This initializer throws an error if reading from the decoder fails, or
  /// if the data read is corrupted or otherwise invalid.
  ///
  /// - Parameter decoder: The decoder to read data from.
  public required convenience init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    do {
      let intValue = try container.decode(Int.self)
      self.init(intValue)
    } catch {
      logF("\(type(of: self).className) decoder catch wrong type")
      do {
        let boolValue = try container.decode(Bool.self)
        if boolValue == true {
          self.init(1)
        } else {
          self.init(0)
        }
      } catch {
        do {
          let doubleValue = try container.decode(Double.self)
          let intValue = Int(doubleValue)
          self.init(intValue)
        } catch {
          do {
            let stringValue = try container.decode(String.self)
            if let intValue = Int(stringValue) {
              self.init(intValue)
            } else {
              logF("\(type(of: self).className) decoder failed -1")
              self.init(-1)
            }
          } catch {
            logF("\(type(of: self).className) decoder failed -2")
            self.init(-2)
          }
        }
      }
    }
  }
}

public class DoubleFlexible: NSObject, Decodable {
  public override var description: String {
    return "\(value)"
  }
  
  public var value: Double
  
  public init(_ value: Double) {
    self.value = value
  }
  
  /// Creates a new instance by decoding from the given decoder.
  ///
  /// This initializer throws an error if reading from the decoder fails, or
  /// if the data read is corrupted or otherwise invalid.
  ///
  /// - Parameter decoder: The decoder to read data from.
  public required convenience init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    do {
      let doubleValue = try container.decode(Double.self)
      self.init(doubleValue)
    } catch {
      logF("\(type(of: self).className) decoder catch wrong type")
      do {
        let boolValue = try container.decode(Bool.self)
        if boolValue == true {
          self.init(1)
        } else {
          self.init(0)
        }
      } catch {
        do {
          let intValue = try container.decode(Int.self)
          let doubleValue = Double(intValue)
          self.init(doubleValue)
        } catch {
          do {
            let stringValue = try container.decode(String.self)
            if let doubleValue = Double(stringValue) {
              self.init(doubleValue)
            } else {
              logF("\(type(of: self).className) decoder failed -1")
              self.init(-1)
            }
          } catch {
            logF("\(type(of: self).className) decoder failed -2")
            self.init(-2)
          }
        }
      }
    }
  }
}
