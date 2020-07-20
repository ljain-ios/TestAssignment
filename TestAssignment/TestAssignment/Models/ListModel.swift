//
//  ListModel.swift
//  TestAssignment
//
//  Created by Lokesh on 20/07/20.
//  Copyright © 2020 Lokesh. All rights reserved.
//

import Foundation

struct ListModel: Decodable {
  var title: String
  var rows: [ListDetailModel]
  
  enum BodyCodingKeys: String, CodingKey{
    case title
    case rows
  }
  
  init(from decoder: Decoder) throws {
    let mainContainer = try decoder.container(keyedBy: BodyCodingKeys.self)
    
    // Decode "title", if null then set to "" and populate the ListModel
    self.title = try mainContainer.decodeIfPresent(String.self, forKey: .title) ?? ""
    
    // Decode "rows",if null then set to [] and populate the ListModel
    let allRows  = try mainContainer.decodeIfPresent([ListDetailModel].self, forKey: .rows) ?? []
    
    if allRows.count > 0 {
      // Discard row where title, imagehref and description all are null
      self.rows = allRows.filter({ (listDetailModel) -> Bool in
        (listDetailModel.title != "") ||
        (listDetailModel.imageHref != "") ||
        (listDetailModel.description != "")
      })
    } else {
      self.rows = []
    }
  }
}
