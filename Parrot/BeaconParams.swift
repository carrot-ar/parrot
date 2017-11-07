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

extension CLBeaconRegion {
  
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
}
