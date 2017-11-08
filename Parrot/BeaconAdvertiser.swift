//
//  BeaconAdvertiser.swift
//  Parrot
//
//  Created by Gonzalo Nunez on 10/30/17.
//  Copyright © 2017 carrot. All rights reserved.
//

import Foundation
import CoreBluetooth
import CoreLocation

/// A class that allows a `CLBeaconRegion` to be advertised.
public final class BeaconAdvertiser: NSObject {
  
  // MARK: Lifecycle
  
  /**
   Initializer that creates the underlying [CLBeaconRegion](https://developer.apple.com/documentation/corelocation/clbeaconregion) that is advertised.
   
   - parameter uuid: The underlying `CLBeaconRegion`'s `proximityUUID`.
   - parameter identifier: The underlying `CLBeaconRegion`'s `identifier`.
   - parameter params: The `BeaconParams` that will be used to populate the underlying `CLBeaconRegion`'s major/minor values.
  */
  public init(
    uuid: UUID,
    identifier: String,
    params: BeaconRegionParams)
  {
    beaconRegion = CLBeaconRegion(
      uuid: uuid,
      identifier: identifier,
      params: params)
    super.init()
  }
  
  deinit {
    stopAdvertising()
  }
  
  // MARK: Public
  
  /**
   Start advertising.
   - parameter onStateChange: A closure to handle when the `BeaconAdvertistingState` changes.
  */
  public func startAdvertising(onStateChange: @escaping (BeaconAdvertiser, BeaconAdvertisingState) -> Void) {
    stateHandler = onStateChange
    updateAdvertisingState()
  }
  
  /// Stop advertising
  public func stopAdvertising() {
    peripheral.stopAdvertising()
    advertisingState = .idle
  }
  
  // MARK: Private
  
  private var stateHandler: ((BeaconAdvertiser, BeaconAdvertisingState) -> Void)!
  private var advertisingState: BeaconAdvertisingState = .idle {
    didSet { stateHandler(self, advertisingState) }
  }
  
  private let beaconRegion: CLBeaconRegion
  private lazy var peripheral: CBPeripheralManager = {
    return CBPeripheralManager(delegate: self, queue: nil)
  }()
  
  private func updateAdvertisingState() {
    if peripheral.isAdvertising {
      return
    }
    let peripheralState = peripheral.state
    switch peripheralState {
    case .poweredOn:
      let data = beaconRegion.peripheralData(withMeasuredPower: nil) as! [String: Any]
      peripheral.startAdvertising(data)
    case .poweredOff, .unknown, .resetting:
      advertisingState = .queued
    case .unsupported:
      advertisingState = .error(BeaconAdvertiserError.unsupported)
    case .unauthorized:
      advertisingState = .error(BeaconAdvertiserError.unauthorized)
    }
  }
}

/// :nodoc:
extension BeaconAdvertiser: CBPeripheralManagerDelegate {
  
  public func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
    updateAdvertisingState()
  }
  
  public func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
    if let error = error {
      advertisingState = .error(error)
      return
    }
    advertisingState = .advertising
  }
}

/// An enum that describes the state of a `BeaconAdvertiser`.
public enum BeaconAdvertisingState {
  /// Waiting for the call to startAdvertising(_:_:).
  case idle
  /// Waiting for the `CBManagerState` to change from .poweredOff, .unknown, or .resetting.
  case queued
  /// The CBPeripheralManager is currently advertising `beaconRegion`.
  case advertising
  /// An error occured.
  case error(Error)
}

/// An enum describing an error originating from a `BeaconAdvertiser`.
public enum BeaconAdvertiserError: Error {
  /// The `CBManagerState` is `.unsupported`.
  case unsupported
  /// The `CBManagerState` is `.unauthorized`.
  case unauthorized
}
