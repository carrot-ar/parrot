//
//  BeaconRanger.swift
//  Parrot
//
//  Created by Gonzalo Nunez on 11/1/17.
//  Copyright © 2017 carrot. All rights reserved.
//

import Foundation
import CoreLocation

/// A class that allows a `CLBeaconRegion` to be monitored.
public final class BeaconMonitor: NSObject {
  
  // MARK: Lifecycle
  
  /**
   Initializer that accepts the [CLBeaconRegion](https://developer.apple.com/documentation/corelocation/clbeaconregion) to be monitored.
   
   - parameter uuid: The underlying `CLBeaconRegion`'s `proximityUUID`.
   - parameter identifier: The underlying `CLBeaconRegion`'s `identifier`.
   - parameter params: The `BeaconParams` that will be used to populate the underlying `CLBeaconRegion`'s major/minor values.
  */
  public init(
    uuid: UUID,
    identifier: String,
    params: BeaconRegionParams)
  {
    beaconRegion = CLBeaconRegion(uuid: uuid, identifier: identifier, params: params)
    beaconRegion.notifyEntryStateOnDisplay = true
    super.init()
  }
  
  deinit {
    stopMonitoring()
  }
  
  // MARK: Public
  
  /**
   Start monitoring the underlying `CLBeaconRegion`.
   
   - parameter onProximityUpdate: A closure that gets passed an instance of `self` along with the current `CLProximity` acquired whenever the `CLBeaconRegion` is ranged.
   - parameter onError: A closure that is called whenever an error occurs.
  */
  public func startMonitoring(
    onProximityUpdate: @escaping (BeaconMonitor, CLProximity) -> Void,
    onError: @escaping (Error) -> Void)
  {
    if let error = error(for: CLLocationManager.authorizationStatus()) {
      onError(error)
      return
    }
    if let error = error(for: UIApplication.shared.backgroundRefreshStatus) {
      onError(error)
      return
    }
    self.onProximityUpdate = onProximityUpdate
    self.onError = onError
    locationManager.requestAlwaysAuthorization()
    locationManager.startMonitoring(for: beaconRegion)
  }
  
  /// Stop monitoring the underlying `CLBeaconRegion`.
  public func stopMonitoring() {
    locationManager.stopRangingBeacons(in: beaconRegion)
    locationManager.stopMonitoring(for: beaconRegion)
  }
  
  // MARK: Private
  
  private var onProximityUpdate: ((BeaconMonitor, CLProximity) -> Void)?
  private var onError: ((Error) -> Void)?
  private let beaconRegion: CLBeaconRegion
  
  private lazy var locationManager: CLLocationManager = {
    let manager = CLLocationManager()
    manager.delegate = self
    return manager
  }()
  
  private func error(for status: CLAuthorizationStatus) -> Error? {
    switch status {
    case .restricted:
      return BeaconMonitorError.locationRestricted
    case .denied:
      return BeaconMonitorError.locationDenied
    case .notDetermined, .authorizedWhenInUse, .authorizedAlways:
      return nil
    }
  }
  
  private func error(for status: UIBackgroundRefreshStatus) -> Error? {
    switch status {
    case .restricted:
      return BeaconMonitorError.backgroundRefreshRestricted
    case .denied:
      return BeaconMonitorError.backgroundRefreshDenied
    case .available:
      return nil
    }
  }
}

/// :nodoc:
extension BeaconMonitor: CLLocationManagerDelegate {
  
  public func locationManager(
    _ manager: CLLocationManager,
    didChangeAuthorization status: CLAuthorizationStatus)
  {
    if let error = error(for: status) {
      onError?(error)
    }
  }
  
  public func locationManager(
    _ manager: CLLocationManager,
    didDetermineState state: CLRegionState,
    for region: CLRegion)
  {
    switch state {
    case .inside:
      locationManager.startRangingBeacons(in: beaconRegion)
    case .outside, .unknown:
      locationManager.stopRangingBeacons(in: beaconRegion)
    }
  }
  
  public func locationManager(
    _ manager: CLLocationManager,
    didEnterRegion region: CLRegion)
  {
    locationManager.startRangingBeacons(in: beaconRegion)
  }
  
  public func locationManager(
    _ manager: CLLocationManager,
    didExitRegion region: CLRegion)
  {
    locationManager.stopRangingBeacons(in: beaconRegion)
  }
  
  public func locationManager(
    _ manager: CLLocationManager,
    didRangeBeacons beacons: [CLBeacon],
    in region: CLBeaconRegion)
  {
    guard let beacon = beacons.first else { return }
    onProximityUpdate?(self, beacon.proximity)
  }
  
  public func locationManager(
    _ manager: CLLocationManager,
    monitoringDidFailFor region: CLRegion?,
    withError error: Error)
  {
    onError?(error)
  }
  
  public func locationManager(
    _ manager: CLLocationManager,
    rangingBeaconsDidFailFor region: CLBeaconRegion,
    withError error: Error)
  {
    onError?(error)
  }
  
  public func locationManager(
    _ manager: CLLocationManager,
    didFailWithError error: Error)
  {
    onError?(error)
  }
}

/// An enum describing an error originating from a `BeaconMonitor`.
enum BeaconMonitorError: Error {
  /// The `CLAuthorizationStatus` is `.denied`.
  case locationDenied
  /// The `CLAuthorizationStatus` is `.restricted`.
  case locationRestricted
  /// The `UIBackgroundRefreshStatus` is `.denied`.
  case backgroundRefreshDenied
  /// The `UIBackgroundRefreshStatus` is `.restricted`.
  case backgroundRefreshRestricted
}
