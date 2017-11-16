//
//  AppDelegate.swift
//  ParrotExample
//
//  Created by Gonzalo Nunez on 11/16/17.
//  Copyright © 2017 carrot. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
  {
    window = UIWindow(frame: UIScreen.main.bounds)
    let vc = ViewController(nibName: nil, bundle: nil)
    window?.rootViewController = vc
    window?.makeKeyAndVisible()
    return true
  }
}

