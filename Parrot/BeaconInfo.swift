//
//  BeaconInfo.swift
//  Parrot
//
//  Created by Gonzalo Nunez on 11/8/17.
//  Copyright © 2017 carrot. All rights reserved.
//

import Foundation
import CoreLocation

/// A struct to help package and serialize information regarding a `CLBeaconRegion`
public struct BeaconInfo {
  
  /// The underlying `CLBeaconRegion`'s `proximityUUID`.
  public var uuid: UUID
  
  /// The underlying `CLBeaconRegion`'s `identifier`.
  public var identifier: String
  
  /// The `BeaconParams` that will be used to populate the underlying `CLBeaconRegion`'s major/minor values.
  public var params: BeaconRegionParams
  
  /**
   - parameter uuid: The underlying `CLBeaconRegion`'s `proximityUUID`.
   - parameter params: The `BeaconParams` that will be used to populate the underlying `CLBeaconRegion`'s major/minor values.
   - parameter identifier: The underlying `CLBeaconRegion`'s `identifier`.
  */
  public init(
    uuid: UUID,
    identifier: String,
    params: BeaconRegionParams)
  {
    self.uuid = uuid
    self.identifier = identifier
    self.params = params
  }
  
  /**
   - parameter region: The underlying `CLBeaconRegion`.
   */
  public init(region: CLBeaconRegion) {
    self.uuid = region.proximityUUID
    self.identifier = region.identifier
    self.params = region.params
  }
}

/// :nodoc:
extension BeaconInfo: Codable {
  
  enum CodingError: Error {
    case decoding(String)
  }
  
  enum CodingKeys: String, CodingKey {
    case uuid
    case identifier
    case params
  }
  
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    guard let uuidString = try? values.decode(String.self, forKey: .uuid),
          let proximityUUID = UUID(uuidString: uuidString)
    else {
      throw CodingError.decoding("Decoding Failed. \(dump(values))")
    }
    uuid = proximityUUID
    identifier = try values.decode(String.self, forKey: .identifier)
    params = (try? values.decode(BeaconRegionParams.self, forKey: .params)) ?? .none
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(uuid.uuidString, forKey: .uuid)
    try container.encode(identifier, forKey: .identifier)
    switch params {
    case .major, .both:
      try container.encode(params, forKey: .params)
    case .none:
      break
    }
  }
}
