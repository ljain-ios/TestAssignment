//
//  ListDetailModel.swift
//  TestAssignment
//
//  Created by Lokesh on 20/07/20.
//  Copyright © 2020 Lokesh. All rights reserved.
//

import Foundation

// Added Equaltable for the Test Cases
struct ListDetailModel: Decodable, Equatable {
  var title: String?, imageHref: String?, description: String?
  
  enum BodyCodingKeys: String, CodingKey{
    case title
    case imageHref
    case description
  }
}
