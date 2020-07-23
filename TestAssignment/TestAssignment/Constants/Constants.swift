//
//  Constants.swift
//  TestAssignment
//
//  Created by Lokesh on 18/07/20.
//  Copyright © 2020 Lokesh. All rights reserved.
//

import Foundation

struct Constants {
  #if RELEASE
  static let baseUrl = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"
  #elseif DEBUG
  static let baseUrl = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"
  #endif
  
  static let kAppName = "Test Assignment"
  static let kNetworkChangeIdentifier = "NetworkChange"
  static let kErrorFetchList = "Something went wrong while fetching the list."
  static let KNoNetwork = "No Network Connection!"
  static let kError = "Error"
  static let kOk = "OK"
  static let kNoRecordFound = "No Records Found"
  static let kListCellIdentifier = "ListCellIdentifier"
}
