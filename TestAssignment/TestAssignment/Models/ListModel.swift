//
//  ListModel.swift
//  TestAssignment
//
//  Created by Lokesh on 20/07/20.
//  Copyright © 2020 Lokesh. All rights reserved.
//

import Foundation

struct ListModel: Decodable {
  var title: String?
  var rows: [ListDetailModel]?
  
  enum BodyCodingKeys: String, CodingKey{
    case title
    case rows
  }
}
