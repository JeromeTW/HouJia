// APIObjects.swift
// Copyright (c) 2019 Jerome Hsieh. All rights reserved.
// Created by Jerome Hsieh.

import Foundation

struct BaseReponse: Decodable, HasResultCode {
  var resultCode: StringFlexible
}

struct PersonalProfileReponse: Decodable, HasResultCode {
  var resultCode: StringFlexible
  var personalProfile: PersonalProfile
}

struct PersonalProfile: Codable {
  var employeeName: StringFlexible
  var employeeID: StringFlexible
  var employeePhotoFileID: StringFlexible
  var authorityLevel: IntFlexible
  var employeePositions: [EmployeePositions]
  var task: Task?
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(employeeName.value, forKey: .employeeName)
    try container.encode(employeeID.value, forKey: .employeeID)
    try container.encode(employeePhotoFileID.value, forKey: .employeePhotoFileID)
    try container.encode(authorityLevel.value, forKey: .authorityLevel)
  }
}

struct EmployeePositions: Decodable {
  var departments: [Department]
  var title: StringFlexible
}

struct Department: Decodable {
  var departmentName: StringFlexible
  var departmentID: StringFlexible
}

struct Task: Decodable, Equatable {
  var number: StringFlexible
  var date: StringFlexible
  var department: StringFlexible
  var level: StringFlexible
  var project: StringFlexible
  var device: StringFlexible
  var exception: StringFlexible // TODO: Delete 沒有用到, exception 也放到 attachments 中
  var attachments: [Attachment]
  var remarks: [Remark]
  var courses: [Course]
  var service: Service?
  var progress: IntFlexible
  
  var isRush: Bool {
    if level.value == "急件" {
      return true
    } else {
      return false
    }
  }
  
  static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.number == rhs.number
  }
}

struct Attachment: Decodable, Equatable {
  var fileID: StringFlexible
  var text: StringFlexible
  var placeHolderText: StringFlexible
  var type: StringFlexible
  var data: Data?
  
  static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.fileID == rhs.fileID && lhs.text == rhs.text && lhs.placeHolderText == rhs.placeHolderText && lhs.type == rhs.type && lhs.data == rhs.data
  }
}

struct Remark: Decodable {
  var personalProfile: PersonalProfile
  // TODO: 大頭照
  var date: StringFlexible
  var content: StringFlexible
}

struct Course: Decodable {
  var date: StringFlexible
  var content: StringFlexible
}

struct Service: Decodable {
  var principalID: StringFlexible
  var helperIDs: [StringFlexible]
  var time: IntFlexible?
  var components: [Component]
  var note: StringFlexible
  var result: StringFlexible
}

struct Component: Decodable {
  var name: StringFlexible
  var number: IntFlexible
}

protocol HasResultCode {
  var resultCode: StringFlexible { get set }
}

public enum APIResultError: Error {
  init(resultCode: String) {
    switch resultCode {
      case "ERR_OK":
        self = .noError
      case "ERR_INVALID_PARAMETERS":
        self = .invalidParameters
      case "ERR_INVALID_LOGIN":
        self = .invalidLogin
      case "ERR_INVALID_ACCESSTOKEN":
        self = .invalidAccesstoken
      case "ERR_INVALID_EMPLOYEEID":
        self = .invalidEmployeeID
      case "ERR_INVALID_PASSWORD":
        self = .invalidPassword
      case "ERR_INVALID_FILEID":
        self = .invalidFileID
      default:
        self = .unkonwn
    }
  }
  
  case noError
  
  case invalidParameters
  
  case invalidLogin
  
  case invalidAccesstoken
  
  case invalidEmployeeID
  
  case invalidPassword
  
  case invalidFileID
  
  case unkonwn
}

extension APIResultError: LocalizedError {
  
  /// 本地化字串
  public var errorDescription: String? {
    switch self {
    case .noError:
      return "一切順利。"
      
    case .invalidParameters:
      return "一個或者多個參數有誤或遺失。"
    
    case .invalidLogin:
      return "登入的員工編號或密碼錯誤。"
    
    case .invalidAccesstoken:
      return "無效的 accessToken。"
      
    case .invalidEmployeeID:
      return "無效的員工編號。"
      
    case .invalidPassword:
      return "密碼錯誤。"
      
    case .invalidFileID:
      return "無效的FileID。"
      
    case .unkonwn:
      return "發生未預期的錯誤"
    }
  }
}
