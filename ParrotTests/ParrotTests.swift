//
//  ParrotTests.swift
//  ParrotTests
//
//  Created by Gonzalo Nunez on 11/7/17.
//  Copyright © 2017 carrot. All rights reserved.
//

import XCTest
@testable import Parrot

import CoreLocation

class ParrotTests: XCTestCase {
  
  let uuid = UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")!
  let identifier = "com.ParrotTests.Beacon"
  
  func testNoParams() {
    let beacon = CLBeaconRegion(uuid: uuid, identifier: identifier, params: .none)
    assert(beacon.identifier == identifier)
    assert(beacon.major == nil)
    assert(beacon.minor == nil)
    switch beacon.params {
    case .none:
      assert(true)
    case .major, .both:
      assert(false, "Unexpected BeaconParams")
    }
  }
  
  func testOnlyMajorParams() {
    let beacon = CLBeaconRegion(uuid: uuid, identifier: identifier, params: .major(100))
    assert(beacon.identifier == identifier)
    assert(beacon.major == 100)
    assert(beacon.minor == nil)
    switch beacon.params {
    case .major:
      assert(true)
    case .none, .both:
      assert(false, "Unexpected BeaconParams")
    }
  }
  
  func testBothMajorAndMinorParams() {
    let beacon = CLBeaconRegion(uuid: uuid, identifier: identifier, params: .both(major: 100, minor: 50))
    assert(beacon.identifier == identifier)
    assert(beacon.major == 100)
    assert(beacon.minor == 50)
    switch beacon.params {
    case .both:
      assert(true)
    case .none, .major:
      assert(false, "Unexpected BeaconParams")
    }
  }
}
