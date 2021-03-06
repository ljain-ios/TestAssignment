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
  let httpLayer = HTTPLayer()
  var networking: ApiClient!
  
  override func setUp() {
    super.setUp()
    networking = ApiClient(httpLayer: httpLayer)
  }
  
  override func tearDown() {
    networking = nil
    super.tearDown()
  }
  
  // MARK: - Test FetchList API Methods
  func testApiCallToFetchList() {
    // Creating the expectation to see if API gives status code 200
    let promise = expectation(description: "Status code: 200")
    
    // Fetch List API Call
    self.httpLayer.request(at: .fetchList) { (data, response, error) in
      if let error = error {
        XCTFail("Error: \(error.localizedDescription)")
        return
      } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
        if statusCode == 200 {
          promise.fulfill()
        } else {
          XCTFail("Status code: \(statusCode)")
        }
      }
    }
    wait(for: [promise], timeout: 30.0)
  }
  
  // Test if API decodes the data correctly
  func testIfDataInCorrectUtf8() {
    let expectationForDecoder = expectation(description: "Status code: 200")
    httpLayer.request(at: .fetchList) { (data, response, error) in
      if let error = error {
        XCTFail("Error: \(error.localizedDescription)")
        return
      } else if let data = data {
        do{
          let decoder = JSONDecoder()
          let list = try decoder.decode(ListModel.self, from: data)
          XCTAssertNotNil(list, "Did not receive list")
          expectationForDecoder.fulfill()
        }catch let error {
          XCTFail("Error: \(error.localizedDescription)")
        }
      }
    }
    wait(for: [expectationForDecoder], timeout: 30.0)
  }
  
  // MARK: - Test Download Image Method
  func testImageDownloadMethod() {
    // Creating the expectation to see if API gives status code 200
    let promise = expectation(description: "Status code: 200")
    
    // Download image call
    self.httpLayer.request(at: .downloadImageFromUrl("http://static.guim.co.uk/sys-images/Music/Pix/site_furniture/2007/04/19/avril_lavigne.jpg")) { (data, response, error) in
      
      if let error = error {
        XCTFail("Error: \(error.localizedDescription)")
        return
      } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
        if statusCode == 200 {
          promise.fulfill()
        } else {
          XCTFail("Status code: \(statusCode)")
        }
      }
    }
    wait(for: [promise], timeout: 30)
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
    XCTAssertEqual(listDecoder.title, nil)
    
    let listDataWithNullRow = Data("""
        {
          "title" : null,
          "rows" : null
        }
        """.utf8)
    
    // Check if decoder decodes the null value of "rows"
    listDecoder = try JSONDecoder().decode(ListModel.self, from: listDataWithNullRow)
    XCTAssertEqual(listDecoder.rows,nil)
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
    XCTAssertEqual(listDetailDecoder.title, nil)
    
    let rowWithNullDesc = Data("""
        {
            "title" : "Test Title",
            "description" : null,
            "imageHref" : "http://dummyimage.jpg"
        }
        """.utf8)
    
    // Check if decoder decodes the null value of "description"
    listDetailDecoder = try JSONDecoder().decode(ListDetailModel.self, from: rowWithNullDesc)
    XCTAssertEqual(listDetailDecoder.description, nil)
    
    let rowWithNullImage = Data("""
        {
            "title" : "Test Title",
            "description" : "Dummy description of test title",
            "imageHref" : null
        }
        """.utf8)
    
    // Check if decoder decodes the null value of "imageHref"
    listDetailDecoder = try JSONDecoder().decode(ListDetailModel.self, from: rowWithNullImage)
    XCTAssertEqual(listDetailDecoder.imageHref, nil)
  }
}
