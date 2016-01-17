//
//  Request.swift
//  Restly
//
//  Created by Alan Stephensen on 5/12/2015.
//  Copyright © 2015 Alan Stephensen. All rights reserved.
//

import Foundation
import Alamofire

class Request {
    var text: String {
        didSet {
            updateRequest()
        }
    }
    var method: String?
    var urlString: String?
    var url: NSURL?
    var headers = [String: String]()
    
    init(text: String) {
        self.text = text
        updateRequest()
    }
    
    func updateRequest() {
        let scanner = NSScanner(string: text)
        
        // The first line will always be the request method and URL.
        var requestText: NSString?
        scanner.scanUpToCharactersFromSet(NSCharacterSet.newlineCharacterSet(), intoString: &requestText)
        
        // Extract the method and url. This will always be the first line of text.
        if let requestText = requestText {
            let methodDividerRange = requestText.rangeOfString(" ")
            if methodDividerRange.location == NSNotFound {
                // No divider means we'll treat the whole line as the method.
                method = requestText as String
            } else {
                // The method is the first bit, the url string is whatever follows.
                method = requestText.substringToIndex(methodDividerRange.location) as String
                urlString = requestText.substringFromIndex(methodDividerRange.location + 1).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                if let urlString = urlString {
                    url = NSURL(string: urlString)   
                }
            }
        }
        
        // Extract the headers.
        // Headers are in the format `Header: Content`. The headers must be provided before any body content.
        // let headerPattern = "^.*?-(.*)\\:(.*)"
        
    }

    // MARK: - Sending
    
    var isSending = false
    var response: NSURLResponse?
    var bodyData: NSData?
    
    func send() {
        isSending = true
        weak var weakSelf = self
        guard let urlAbsoluteString = url?.absoluteString else {
            return
        }
        guard let method = method else {
            return
        }
        Alamofire.request(.fromString(method), urlAbsoluteString).responseString { response in
            weakSelf?.isSending = false
            print(response)
        }
    }
    
}