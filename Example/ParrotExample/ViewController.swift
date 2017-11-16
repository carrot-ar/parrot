//
//  ViewController.swift
//  ParrotExample
//
//  Created by Gonzalo Nunez on 11/16/17.
//  Copyright © 2017 carrot. All rights reserved.
//

import UIKit
import Parrot

class ViewController: UIViewController {
  
  // MARK: Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    
    view.addSubview(rangeSwitch)
    NSLayoutConstraint.activate([
      rangeSwitch.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      rangeSwitch.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])
    
    let shouldRangeLabel = UILabel(frame: .zero)
    shouldRangeLabel.text = "Range"
    shouldRangeLabel.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(shouldRangeLabel)
    NSLayoutConstraint.activate([
      shouldRangeLabel.leftAnchor.constraint(equalTo: rangeSwitch.rightAnchor, constant: 8),
      shouldRangeLabel.centerYAnchor.constraint(equalTo: rangeSwitch.centerYAnchor)
    ])
    
    infoLabel.text = "Idle..."
    infoLabel.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(infoLabel)
    NSLayoutConstraint.activate([
      infoLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
      infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    ])
    
    view.addSubview(startButton)
    NSLayoutConstraint.activate([
      startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      startButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
    ])
  }
  
  // MARK: Private
  
  private var advertiser: BeaconAdvertiser?
  private var monitor: BeaconMonitor?
  
  private enum State {
    case wantsMonitoring
    case wantsAdvertising
    case monitoring
    case advertising
  }
  
  private var state: State = .wantsAdvertising {
    didSet { handleStateChange(from: oldValue) }
  }
  
  lazy private var rangeSwitch: UISwitch = {
    let uiSwitch = UISwitch(frame: .zero)
    uiSwitch.translatesAutoresizingMaskIntoConstraints = false
    uiSwitch.addTarget(self, action: #selector(handleSwitch), for: .valueChanged)
    return uiSwitch
  }()
  
  lazy private var startButton: UIButton = {
    let button = UIButton(type: .system)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Start", for: .normal)
    button.addTarget(self, action: #selector(handleStartButton), for: .touchUpInside)
    return button
  }()
  
  private var infoLabel = UILabel(frame: .zero)
  
  @objc private func handleSwitch(sender: Any) {
    let shouldRange = rangeSwitch.isOn
    state = shouldRange ? .wantsMonitoring : .wantsAdvertising
  }
  
  @objc private func handleStartButton(sender: Any) {
    let uuid = UUID(uuidString: "CFC5128B-96FD-40FD-A4C4-D099F22E9E64")!
    switch state {
    case .wantsMonitoring:
      monitor = BeaconMonitor(
        uuid: uuid,
        identifier: "com.ParrotExample.Beacon",
        params: .none)
      startButton.setTitle("Stop", for: .normal)
      state = .monitoring
      monitor?.startMonitoring(
        onProximityUpdate: { [weak self] monitor, proximity in
          switch proximity {
          case .unknown:
            self?.infoLabel.text = "Unknown..."
          case .far:
            self?.infoLabel.text = "Far..."
          case .near:
            self?.infoLabel.text = "Near..."
          case .immediate:
            self?.infoLabel.text = "Immediate!"
          }
        },
        onError: { [weak self] error in
          print("ERROR: \(error)")
          self?.infoLabel.text = error.localizedDescription
        }
      )
    case .wantsAdvertising:
      advertiser = BeaconAdvertiser(
        uuid: uuid,
        identifier: "com.ParrotExample.Beacon", 
        params: .none)
      startButton.setTitle("Stop", for: .normal)
      state = .advertising
      advertiser?.startAdvertising { [weak self] advertiser, state in
        self?.infoLabel.text = "\(state)...".capitalized
      }
    case .monitoring:
      startButton.setTitle("Start", for: .normal)
      monitor?.stopMonitoring()
      state = .wantsMonitoring
    case .advertising:
      startButton.setTitle("Start", for: .normal)
      advertiser?.stopAdvertising()
      state = .wantsAdvertising
    }
  }
  
  private func handleStateChange(from previous: State) {
    switch (state, previous) {
    case (.wantsMonitoring, .wantsAdvertising):
      advertiser = nil
      startButton.setTitle("Start", for: .normal)
      self.infoLabel.text = "Idle..."
    case (.wantsAdvertising, .wantsMonitoring):
      monitor = nil
      startButton.setTitle("Start", for: .normal)
      self.infoLabel.text = "Idle..."
    default:
      break
    }
  }
}
