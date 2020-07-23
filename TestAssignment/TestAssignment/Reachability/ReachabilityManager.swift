//
//  ReachabilityManager.swift
//  TestAssignment
//
//  Created by Lokesh on 20/07/20.
//  Copyright © 2020 Lokesh. All rights reserved.
//

import UIKit
import Reachability

class ReachabilityManager: NSObject {
  var reachability: Reachability?
  var isNetworkRechable: Bool = true
  
  static var sharedManager: ReachabilityManager = {
    let reachabilityManager = ReachabilityManager()
    return reachabilityManager
  }()
  
  func setupReachability() {
    // Start Reachability Notifier
    reachability = try? Reachability()
    NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(notification:)), name: .reachabilityChanged, object: reachability)
    do{
      try reachability!.startNotifier()
    } catch {
    }
  }
  
  // Reachability change method
  @objc func reachabilityChanged(notification: Notification?) {
    if (notification == nil && self.isNetworkRechable == true) {
      return
    }
    switch reachability!.connection {
    case .wifi:
      isNetworkRechable = true
    case .cellular:
      isNetworkRechable = true
    case .unavailable:
      isNetworkRechable = false
    case .none:
      isNetworkRechable = false
    }
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants.kNetworkChangeIdentifier), object: nil)
  }
}
