//
//  ApiClient.swift
//  TestAssignment
//
//  Created by Lokesh on 20/07/20.
//  Copyright © 2020 Lokesh. All rights reserved.
//

import Foundation

class ApiClient {
  var httpLayer: HTTPLayer
  
  enum Result<Element> {
    case success(Element)
    case failure(Error)
  }
  
  init(httpLayer: HTTPLayer) {
    self.httpLayer = httpLayer
  }
  
  // Fetch List API Call
  func fetchList(completion: @escaping (Result<ListModel>) -> Void) {
    self.httpLayer.request(at: .fetchList) { (data, response, error) in
      guard let httpResponse = response as? HTTPURLResponse,
        httpResponse.statusCode.isSuccessHTTPCode,
        let listData = data
        else {
          if let error = error {
            // Error :- List could not be fetched
            completion(.failure(error))
          }
          return
      }
      do {
        let decoder = JSONDecoder()
        
        // Passing the listData to populate ListModel
        let list = try decoder.decode(ListModel.self, from: listData)
        completion(.success(list))
      } catch let error {
        // Error :- Data could not be decoded correctly
        completion(.failure(error))
      }
    }
  }
}

// MARK: - Int Extension
extension Int {
  public var isSuccessHTTPCode: Bool {
    return 200 <= self && self < 300
  }
}
