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
    
    class func requestsFromText(text: String) -> (requests: [Request], requestRanges: [NSRange]) {
        // Requests are determined by finding lines that start with a valid request method.
        let methods = ["GET", "PUT", "POST", "PATCH", "DELETE", "HEAD", "OPTIONS", "TRACE", "CONNECT"]
        
        // Create expressions that will be used to match methods.
        let joinedMethods = methods.joinWithSeparator("|")
        let expressionPattern = "^(\(joinedMethods))"
        let methodExpression = try? NSRegularExpression(pattern: expressionPattern, options: .AnchorsMatchLines)
        guard methodExpression != nil else {
            return ([], [])
        }
        
        // Create the arrays to hold the requests and ranges.
        var requests: [Request] = []
        var requestRanges: [NSRange] = []
        
        // Convert the Swift string to an NSString so that it can be used in regex.
        let textNSString = text as NSString
        
        // Loop through all of the matches and create the requests.
        if let matches = methodExpression?.matchesInString(text, options: NSMatchingOptions(), range: NSMakeRange(0, textNSString.length)) {
            for (matchIndex, match) in matches.enumerate() {
                // Find the real range of the request. The last object will contain the rest of the text, otherwise it will be the start of the next match.
                let matchLocation = match.range.location
                var matchLength = 0
                // Check if it is the last object
                if matches.last == match {
                    matchLength = textNSString.length - matchLocation
                } else {
                    // Find the next match, the request text will be 'up to' the next one.
                    let nextMatch = matches[matchIndex + 1]
                    matchLength = nextMatch.range.location - match.range.location
                }
                // Extract the request text, create the request and add it to the array.
                // TODO: Think about trimming trailing space. The range would need to be adjusted too.
                let matchRange = NSMakeRange(matchLocation, matchLength)
                let requestText = textNSString.substringWithRange(matchRange)
                let request = Request(text: requestText)
                requests.append(request)
                requestRanges.append(matchRange)
            }
        }
        return (requests, requestRanges)
    }
    
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