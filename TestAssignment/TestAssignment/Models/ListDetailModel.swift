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
  var title: String, imageHref: String, description: String
  
  enum BodyCodingKeys: String, CodingKey{
    case title
    case imageHref
    case description
  }
  
  init(from decoder: Decoder) throws {
    let mainContainer = try decoder.container(keyedBy: BodyCodingKeys.self)
    
    // Decode "title", if null then set to "" and populate the ListDetailModel
    self.title       = (try mainContainer.decodeIfPresent(String.self, forKey: .title)) ?? ""
    
    // Decode "imageHref", if null then set to "" and populate the ListDetailModel
    self.imageHref   = (try mainContainer.decodeIfPresent(String.self, forKey: .imageHref)) ?? ""
    
    // Decode "description", if null then set to "" and populate the ListDetailModel
    self.description = (try mainContainer.decodeIfPresent(String.self, forKey: .description)) ?? ""
  }
}
