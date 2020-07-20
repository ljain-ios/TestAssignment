//
//  TestAssignmentTests.swift
//  TestAssignmentTests
//
//  Created by Lokesh on 20/07/20.
//  Copyright © 2020 Lokesh. All rights reserved.
//

import XCTest
@testable import TestAssignment

class TestAssignmentTests: XCTestCase {
  
  override func setUpWithError() throws {
  }
  
  override func tearDownWithError() throws {
  }
  
  // MARK: - Test ListModel Decoder Method
  func testDecoderToPopulateListModel() throws {
    let listData = Data("""
        {
          "title" : "canada",
          "rows" : [
                    {
                    "title" : "Test Title",
                    "description" : "Dummy description of test title",
                    "imageHref" : "http://dummyimage.jpg"
                    }
            ]
        }
        """.utf8)
    
    // Check if decoder decodes the "title" from the sample data
    var listDecoder = try JSONDecoder().decode(ListModel.self, from: listData)
    XCTAssertEqual(listDecoder.title, "canada")
    
    let listDataWithNullTitle = Data("""
        {
          "title" : null,
          "rows" : [
                    {
                    "title" : "Test Title",
                    "description" : "Dummy description of test title",
                    "imageHref" : "http://dummyimage.jpg"
                    }
            ]
        }
        """.utf8)
    
    // Check if decoder decodes the null value of "title"
    listDecoder = try JSONDecoder().decode(ListModel.self, from: listDataWithNullTitle)
    XCTAssertEqual(listDecoder.title, "")
    
    let listDataWithNullRow = Data("""
        {
          "title" : null,
          "rows" : null
        }
        """.utf8)
    
    // Check if decoder decodes the null value of "rows"
    listDecoder = try JSONDecoder().decode(ListModel.self, from: listDataWithNullRow)
    XCTAssertEqual(listDecoder.rows.count, 0)
    XCTAssertEqual(listDecoder.rows,[])
  }
  
  // MARK: - Test ListDetailModel Decoder Method
  func testDecoderToPopulateListDetailModel() throws {
    let rowData = Data("""
        {
            "title" : "Test Title",
            "description" : "Dummy description of test title",
            "imageHref" : "http://dummyimage.jpg"
        }
        """.utf8)
    
    // Check if decoder decodes the row data
    var listDetailDecoder = try JSONDecoder().decode(ListDetailModel.self, from: rowData)
    XCTAssertEqual(listDetailDecoder.title, "Test Title")
    
    let rowWithNullTitle = Data("""
        {
            "title" : null,
            "description" : "Dummy description of test title",
            "imageHref" : "http://dummyimage.jpg"
        }
        """.utf8)
    
    // Check if decoder decodes the null value of "title"
    listDetailDecoder = try JSONDecoder().decode(ListDetailModel.self, from: rowWithNullTitle)
    XCTAssertEqual(listDetailDecoder.title, "")
    
    let rowWithNullDesc = Data("""
        {
            "title" : "Test Title",
            "description" : null,
            "imageHref" : "http://dummyimage.jpg"
        }
        """.utf8)
    
    // Check if decoder decodes the null value of "description"
    listDetailDecoder = try JSONDecoder().decode(ListDetailModel.self, from: rowWithNullDesc)
    XCTAssertEqual(listDetailDecoder.description, "")
    
    let rowWithNullImage = Data("""
        {
            "title" : "Test Title",
            "description" : "Dummy description of test title",
            "imageHref" : null
        }
        """.utf8)
    
    // Check if decoder decodes the null value of "imageHref"
    listDetailDecoder = try JSONDecoder().decode(ListDetailModel.self, from: rowWithNullImage)
    XCTAssertEqual(listDetailDecoder.imageHref, "")
  }
}
