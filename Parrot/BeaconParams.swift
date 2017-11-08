//
//  BeaconParams.swift
//  Parrot
//
//  Created by Gonzalo Nunez on 11/7/17.
//  Copyright © 2017 carrot. All rights reserved.
//

import Foundation
import CoreLocation

/// An enum describing what the major/minor values of the underlying `CLBeaconRegion` will be.
public enum BeaconRegionParams {
  /// No values provided
  case none
  /// Only a major value is provided
  case major(UInt16)
  /// Both a major and a minor value are provided
  case both(major: UInt16, minor: UInt16)
}

/// :nodoc:
extension BeaconRegionParams: Codable {

  public enum CodingKeys: String, CodingKey {
    case major
    case minor
  }
  
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    let decodedMajor = try? values.decode(UInt16.self, forKey: .major)
    let decodedMinor = try? values.decode(UInt16.self, forKey: .minor)
    switch (decodedMajor, decodedMinor) {
    case (.none, _):
      self = .none
    case let (major?, .none):
      self = .major(major)
    case let (major?, minor?):
      self = .both(major: major, minor: minor)
    }
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    switch self {
    case .none:
      break
    case let .major(major):
      try container.encode(major, forKey: .major)
    case let .both(major: major, minor: minor):
      try container.encode(major, forKey: .major)
      try container.encode(minor, forKey: .minor)
    }
  }
}

/// An extension that allows `CLBeaconRegion`s to be used with `BeaconRegionParams`
extension CLBeaconRegion {
  
  /// A convenience initializer to create a `CLBeaconRegion` with `BeaconRegionParams`.
  convenience init(
    uuid: UUID,
    identifier: String,
    params: BeaconRegionParams)
  {
    switch params {
    case .none:
      self.init(
        proximityUUID: uuid,
        identifier: identifier)
    case let .major(major):
      self.init(
        proximityUUID: uuid,
        major: major,
        identifier: identifier)
    case let .both(major, minor):
      self.init(
        proximityUUID: uuid,
        major: major,
        minor: minor,
        identifier: identifier)
    }
  }
  
  /// Returns the corresponding `BeaconRegionParams` of the receiver.
  public var params: BeaconRegionParams {
    switch (major, minor) {
    case (.none, .none), (.none, _):
      return .none
    case let (major?, .none):
      return .major(major.uint16Value)
    case let (major?, minor?):
      return .both(major: major.uint16Value, minor: minor.uint16Value)
    }
  }
}
