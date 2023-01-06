//
//  Extensions.swift
//  AlcatelApp
//
//  Created by Kamil Szymeczko on 08/04/2022.
//

import Foundation

extension String {

    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}

extension StringProtocol {
    var asciiValues: [UInt8] { compactMap(\.asciiValue) }
}

extension Bool {
    static func ^ (left: Bool, right: Bool) -> Bool {
        return left != right
    }
}

enum JSON {
    case double(Double)
    case integer(Int)
    case string(String)
    case boolean(Bool)
    case null
    indirect case array([JSON])
    indirect case object([String: JSON])
}

extension JSON: Encodable {
  func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    switch self {
    case .double(let value):
        try container.encode(value)
    case .integer(let value):
        try container.encode(value)
    case .string(let value):
        try container.encode(value)
    case .boolean(let value):
        try container.encode(value)
    case .null:
        try container.encodeNil()
    case .array(let value):
        try container.encode(value)
    case .object(let value):
        try container.encode(value)
    }
  }
}

extension JSON: Decodable {
  init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()

    if let value = try? container.decode(Int.self) {
      self = .integer(value)
      return
    }

    if let value = try? container.decode(Double.self) {
      self = .double(value)
      return
    }

    if let value = try? container.decode(Bool.self) {
      self = .boolean(value)
      return
    }

    if let value = try? container.decode(String.self) {
      self = .string(value)
      return
    }

    if let value = try? container.decode([JSON].self) {
      self = .array(value)
      return
    }

    if let value = try? container.decode([String: JSON].self) {
      self = .object(value)
      return
    }

    if
      let container = try? decoder.singleValueContainer(),
      container.decodeNil()
    {
      self = .null
      return
    }

    throw DecodingError.dataCorrupted(
      .init(
        codingPath: container.codingPath,
        debugDescription: "Cannot decode JSON"
      )
    )
  }
}

extension JSON {
  var int: Int? {
    guard case let .integer(value) = self else {
      return nil
    }
    return value
  }
  
  var double: Double? {
    guard case let .double(value) = self else {
      return nil
    }
    return value
  }
  
  var string: String? {
    guard case let .string(value) = self else {
      return nil
    }
    return value
  }
  
  var isNil: Bool {
    guard case .null = self else {
      return false
    }
    return true
  }
  
  var bool: Bool? {
    guard case let .boolean(value) = self else {
      return nil
    }
    return value
  }
  
  var array: [JSON]? {
    guard case let .array(value) = self else {
      return nil
    }
    return value
  }
  
  var object: [String: JSON]? {
    guard case let .object(value) = self else {
      return nil
    }
    return value
  }
}

extension String {
    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
}
