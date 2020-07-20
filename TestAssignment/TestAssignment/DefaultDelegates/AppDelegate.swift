//
//  AppDelegate.swift
//  TestAssignment
//
//  Created by Lokesh on 20/07/20.
//  Copyright © 2020 Lokesh. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Setup reachability
    ReachabilityManager.sharedManager.setupReachability()
    
    // Check iOS before configuring UIWindow
    if #available(iOS 13.0, *) {
      // Set rootViewController in SceneDelegate
    } else {
      // Configuring UIWindow and setting its rootViewController
      let window = UIWindow(frame: UIScreen.main.bounds)
      window.rootViewController = UINavigationController(rootViewController: ListViewController()) // Our initial view controller.
      window.makeKeyAndVisible()
      self.window = window
    }
    return true
  }
  
  // MARK: UISceneSession Lifecycle
  @available(iOS 13.0, *)
  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }
  
  @available(iOS 13.0, *)
  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
  }
  
  
}

