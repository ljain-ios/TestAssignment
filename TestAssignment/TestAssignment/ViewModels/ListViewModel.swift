//
//  ListViewModel.swift
//  TestAssignment
//
//  Created by Lokesh on 20/07/20.
//  Copyright © 2020 Lokesh. All rights reserved.
//

import Foundation

class ListViewModel {
  let httpLayer = HTTPLayer()
  let networking: ApiClient
  var listData: ListModel?
  
  // MARK: - Class Methods
  init(){
    // Initialize networking for API Calls
    networking = ApiClient(httpLayer: httpLayer)
  }
  
  // Get List API Call
  func getList(completion: @escaping (NSError?) -> Void) {
    networking.fetchList() { [weak self] (result) in
      guard let self = self else {
        return
      }
      switch result{
      case .failure(let error):
        completion(error as NSError)
        print(error)
      case .success(let list):
        self.listData = list
        completion(nil)
      }
    }
  }
}
