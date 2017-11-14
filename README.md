<p align="center">
<img src="https://github.com/carrot-ar/carrot-ios/wiki/resources/Parrot@2x.png" alt="Carrot" width="300">
</p>

[![Platforms](https://img.shields.io/cocoapods/p/Parrot.svg?style=flat)](https://github.com/carrot-ar/parrot/)
[![Pods version](https://img.shields.io/cocoapods/v/Parrot.svg?style=flat)](https://cocoapods.org/pods/Parrot)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Build Status](https://travis-ci.org/carrot-ar/parrot.svg?branch=master)](https://travis-ci.org/carrot-ar/parrot)

Parrot is a (very) small Swift framework that helps with advertising an iOS device as an iBeacon as well as monitoring/ranging for iBeacons.

### 🎙 Broadcasting an iBeacon Signal

Parrot allows you to [turn your device into an iBeacon](https://developer.apple.com/documentation/corelocation/turning_an_ios_device_into_an_ibeacon) by doing the following:

```swift
let uuid = UUID(string: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")!
let beaconAdvertiser = BeaconAdvertiser(uuid: uuid, identifier: "com.myCompany.BeaconIdentifier", params: .none)
beaconAdvertiser.startAdvertising { advertiser, state in 
  print("State: \(state) for \(advertiser)")
}
```

### 🔊 Determining the Proximity to an iBeacon

Parrot also allows you to very easily [determine the proximity to an iBeacon](https://developer.apple.com/documentation/corelocation/determining_the_proximity_to_an_ibeacon) by doing the following:

```swift
let uuid = UUID(string: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")!
let beaconMonitor = BeaconMonitor(uuid: uuid, identifier: "com.myCompany.BeaconIdentifier", params: .none)
beaconMonitor.startMonitoring(
  onProximityUpdate: { monitor, proximity in
    print("Proximity: \(proximity) for \(monitor)")
  },
  onError: { error in
    print("Error occured: \(error)")       
  }
)
```

### 🛠 Installation

Parrot is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```
pod "Parrot"
```

Parrot is also available through [Carthage](https://github.com/Carthage/Carthage). Add this to your Cartfile:

```
github "carrot-ar/Parrot"
```

### 🥕 More

To see where we use Parrot ourselves, check out [carrot-ios](https://github.com/carrot-ar/carrot-ios)!
