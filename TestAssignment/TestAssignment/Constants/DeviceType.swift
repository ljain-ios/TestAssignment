//
//  DeviceType.swift
//  TestAssignment
//
//  Created by Lokesh on 18/07/20.
//  Copyright © 2020 Lokesh. All rights reserved.
//

import UIKit

struct ScreenSize {
  static let width = UIScreen.main.bounds.size.width
  static let height = UIScreen.main.bounds.size.height
  static let maxLength = max(ScreenSize.width, ScreenSize.height)
  static let minLength = min(ScreenSize.width, ScreenSize.height)
}

// Type of Device based on Screen Size
struct DeviceType {
  static let iPhoneSE = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxLength <= 568.0
  static let iPhone8 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxLength == 667.0
  static let iPhone8Plus = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxLength >= 736.0
  static let iPhoneX = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxLength == 812.0 // Also iPhone XR
  static let iPhoneXsMax = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxLength == 896.0
  static let iPhone = UIDevice.current.userInterfaceIdiom == .phone
  static let iPad = UIDevice.current.userInterfaceIdiom == .pad
  
  static var hasTopNotch: Bool {
    return iPhoneX || iPhoneXsMax
  }
}
