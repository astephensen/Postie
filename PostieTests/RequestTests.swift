//
//  RequestTests.swift
//  Postie
//
//  Created by Alan Stephensen on 5/12/2015.
//  Copyright © 2015 Alan Stephensen. All rights reserved.
//

import XCTest
@testable import Postie

class RequestTests: XCTestCase {

    func testCreatingRequest() {
        let text = "GET http://example.com"
        let request = Request(text: text)
        XCTAssertNotNil(request, "Request should not be nil")
        XCTAssertEqual(request.text, text, "Request text property should be '\(text)' received '\(request.text)'")
        XCTAssertEqual(request.url?.absoluteString, "http://example.com", "Request URL should be http://example.com")
    }
    
    func testCreatingRequestWithNoScheme() {
        let text = "GET example.com"
        let request = Request(text: text)
        XCTAssertNotNil(request, "Request should not be nil")
        XCTAssertEqual(request.text, text, "Request text property should be '\(text)' received '\(request.text)'")
        XCTAssertEqual(request.url?.absoluteString, "http://example.com", "Request URL should be http://example.com")
    }
    
    func testCreatingRequestWithLocalPort() {
        let text = "GET :8080"
        let request = Request(text: text)
        XCTAssertNotNil(request, "Request should not be nil")
        XCTAssertEqual(request.text, text, "Request text property should be '\(text)' received '\(request.text)'")
        XCTAssertEqual(request.url?.absoluteString, "http://localhost:8080", "Request URL should be http://localhost:8080")
    }
    
    func testRequestMethod() {
        let methods = ["GET", "PUT", "POST", "DELETE", "HEAD", "PATCH"]
        for method in methods {
            let text = "\(method) http://example.com"
            let request = Request(text: text)
            XCTAssertNotNil(request, "Request should not be nil")
            XCTAssertEqual(request.text, text, "Request text property should be '\(text)' received '\(request.text)'")
            XCTAssertNotNil(request.method, "Request method should not be nil")
            XCTAssertEqual(request.method, method, "Request method property should be '\(method)' received '\(request.method)'")
        }
    }
    
    func testURLString() {
        let urlString = "http://example.com"
        let text = "GET \(urlString)"
        let request = Request(text: text)
        XCTAssertNotNil(request, "Request should not be nil")
        XCTAssertEqual(request.urlString, urlString, "Request urlString should be '\(urlString)' received '\(request.urlString)'")
    }
    
    /* Headers */
    
    func testRequestHeaders() {
        let text = "GET http://example.com\n" +
                   "headerOne: firstHeader\n" +
                   "headerTwo:secondHeader\n" +
                   "headerThree: thirdHeader"
        let request = Request(text: text)
        XCTAssertEqual(request.headers.count, 3, "Request should have three headers, has \(request.headers.count)")
    }
    
    /* Form Data */
    
    func testFormData() {
        let text = "GET http://example.com\n" +
                   "key = value"
        let request = Request(text: text)
        XCTAssertEqual(request.formData.count, 1, "Request should have form data")
        XCTAssertEqual(request.formData.first!.0, "key")
        XCTAssertEqual(request.formData.first!.1, "value")
    }
    
    /* Body Data */
    
    func testBodyData() {
        let text = "GET http://example.com\n" +
                   "body data"
        let request = Request(text: text)
        XCTAssertEqual(request.bodyText, "body data")
    }
    
    func testJSON() {
        let text = "GET http://example.com\n" +
                   "{\"json\": true}"
        let request = Request(text: text)
        XCTAssertNotNil(request.bodyJSON, "Request should have body json")
    }
    
    func testMultiLineJSON() {
        let text = "GET http://example.com\n" +
                   "{" +
                   "  \"hello\": \"world\"" +
                   "}"
        let request = Request(text: text)
        XCTAssertNotNil(request.bodyJSON, "Request should have body json")
    }
}