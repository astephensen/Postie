//
//  DocumentTests.swift
//  Restly
//
//  Created by Alan Stephensen on 8/12/2015.
//  Copyright © 2015 Alan Stephensen. All rights reserved.
//

import XCTest
@testable import Restly

class DocumentTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /* Request Counts */
    
    func testCreatingBlankDocument() {
        let document = Document()
        XCTAssertNotNil(document, "Blank document could not be created")
    }
    
    func testCreatingDocument() {
        let document = Document(text: "Hello")
        XCTAssertNotNil(document, "Document could not be created.")
    }
    
    func testSingleRequest() {
        let simpleRequest = "GET http://example.com"
        let document = Document(text: simpleRequest)
        XCTAssertNotNil(document.requests, "Document should not have nil requests.")
        XCTAssert(document.requests.count == 1, "Document should contain a single request.")
    }
    
    func testMultipleRequests() {
        let multipleRequests = "GET http://example.com\n\nPUT http://example.com\n\nPOST http://example.com\n\n"
        let document = Document(text: multipleRequests)
        XCTAssert(document.requests.count == 3, "Document should contain 3 requests, contains \(document.requests.count).")
    }
    
    func testUnknownMethod() {
        let unknownMethod = "LOL http://example.com"
        let document = Document(text: unknownMethod)
        XCTAssert(document.requests.count == 0, "Document should not contain any requests.")
    }
    
    /* Requests */
    
    /*
    func testRequestAtLocation() {
        let request = "GET http://example.com\n\nPUT http://example.com\n\nPOST http://example.com\n\n"
        var document = Document(text: request)
        XCTAssertNotNil(document.requestAtLocation(10), "Request should exist at location.")
        XCTAssertNil(document.requestAtLocation(100), "Request should not exist at location.")
        // SWIFT: Couldn't use Equal for some reason?
        XCTAssert(document.requests[1] === document.requestAtLocation(30), "Request at location 30 should be the second request.")
    }
    */

}
