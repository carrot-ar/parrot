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
    assert(beacon.proximityUUID == uuid)
    assert(beacon.identifier == identifier)
    assert(beacon.major == nil)
    assert(beacon.minor == nil)
    switch beacon.params {
    case .none:
      break
    case .major, .both:
      assert(false, "Unexpected BeaconParams")
    }
  }
  
  func testOnlyMajorParams() {
    let beacon = CLBeaconRegion(uuid: uuid, identifier: identifier, params: .major(100))
    assert(beacon.proximityUUID == uuid)
    assert(beacon.identifier == identifier)
    assert(beacon.major == 100)
    assert(beacon.minor == nil)
    switch beacon.params {
    case .major:
      break
    case .none, .both:
      assert(false, "Unexpected BeaconParams")
    }
  }
  
  func testBothMajorAndMinorParams() {
    let beacon = CLBeaconRegion(uuid: uuid, identifier: identifier, params: .both(major: 100, minor: 50))
    assert(beacon.proximityUUID == uuid)
    assert(beacon.identifier == identifier)
    assert(beacon.major == 100)
    assert(beacon.minor == 50)
    switch beacon.params {
    case .both:
      break
    case .none, .major:
      assert(false, "Unexpected BeaconParams")
    }
  }
  
  func testNoneBeaconParamsJSON() {
    let beaconRegionParams = BeaconRegionParams.none
    let data = try? JSONEncoder().encode(beaconRegionParams)
    XCTAssertNotNil(data)
    let decoded = try? JSONDecoder().decode(BeaconRegionParams.self, from: data!)
    XCTAssertNotNil(decoded)
    switch (beaconRegionParams, decoded!) {
    case (.none, .none):
      break
    default:
      assert(false, "Unexpected BeaconParams")
    }
  }
  
  func testMajorBeaconParamsJSON() {
    let beaconRegionParams = BeaconRegionParams.major(100)
    let data = try? JSONEncoder().encode(beaconRegionParams)
    XCTAssertNotNil(data)
    let decoded = try? JSONDecoder().decode(BeaconRegionParams.self, from: data!)
    XCTAssertNotNil(decoded)
    switch (beaconRegionParams, decoded!) {
    case let (.major(major1), .major(major2)):
      assert(major1 == major2)
    default:
      assert(false, "Unexpected BeaconParams")
    }
  }
  
  func testBothBeaconParamsJSON() {
    let beaconRegionParams = BeaconRegionParams.both(major: 100, minor: 50)
    let data = try? JSONEncoder().encode(beaconRegionParams)
    XCTAssertNotNil(data)
    let decoded = try? JSONDecoder().decode(BeaconRegionParams.self, from: data!)
    XCTAssertNotNil(decoded)
    switch (beaconRegionParams, decoded!) {
    case let (.both(major1, minor1), .both(major2, minor2)):
      assert(major1 == major2)
      assert(minor1 == minor2)
    default:
      assert(false, "Unexpected BeaconParams")
    }
  }
  
  func testBeaconInfoJSON() {
    let params = BeaconRegionParams.both(major: 100, minor: 50)
    let beaconInfo = BeaconInfo(uuid: uuid, identifier: identifier, params: params)
    let data = try? JSONEncoder().encode(beaconInfo)
    XCTAssertNotNil(data)
    let decoded = try? JSONDecoder().decode(BeaconInfo.self, from: data!)
    XCTAssertNotNil(decoded)
    assert(beaconInfo.uuid == uuid)
    assert(beaconInfo.identifier == identifier)
    switch (beaconInfo.params, params) {
    case let (.both(major1, minor1), .both(major2, minor2)):
      assert(major1 == major2)
      assert(minor1 == minor2)
    default:
      assert(false, "Unexpected BeaconParams")
    }
  }
}
