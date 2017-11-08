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
  }
  
  func testOnlyMajorParams() {
    let beacon = CLBeaconRegion(uuid: uuid, identifier: identifier, params: .major(100))
    assert(beacon.identifier == identifier)
    assert(beacon.major == 100)
    assert(beacon.minor == nil)
  }
  
  func testBothMajorAndMinorParams() {
    let beacon = CLBeaconRegion(uuid: uuid, identifier: identifier, params: .both(major: 100, minor: 50))
    assert(beacon.identifier == identifier)
    assert(beacon.major == 100)
    assert(beacon.minor == 50)
  }
}
