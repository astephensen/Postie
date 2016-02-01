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
    var headers: [String: String] = [:]
    var formData: [String: String] = [:]
    var bodyJSON: AnyObject?
    
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
        
        // Scan each line of the request.
        // - Headers should have a colon anywhere in the line. e.g. Header: Value
        // - Form data should have an equals sign anywhere in the line. e.g. Form = Data
        // - JSON data is a line that starts with a curly bracket or square bracket.
        // If JSON data is encountered then any further processing will be.
        while (!scanner.atEnd) {
            var scannedText: NSString?
            scanner.scanUpToCharactersFromSet(NSCharacterSet.newlineCharacterSet(), intoString: &scannedText)
            guard var lineText = scannedText as? String else {
                continue
            }
            // Trim any whitespace characters.
            lineText = lineText.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            
            // Check if it is JSON. TODO: Should we bother with parsing it to JSON or just store the body as text?
            let firstCharacter = lineText[lineText.startIndex]
            if firstCharacter == "{" || firstCharacter == "[" {
                let bodyText = text.substringFromIndex(text.startIndex.advancedBy(scanner.scanLocation - 1))
                do {
                    let parsedJSON = try NSJSONSerialization.JSONObjectWithData(bodyText.dataUsingEncoding(NSUTF8StringEncoding)!, options: [])
                    bodyJSON = parsedJSON
                } catch { }
                break
            }
            
            // Look for headers. TODO: Can this handle colons elsewhere? Do headers even have other colons?
            if lineText.containsString(":") {
                let headerComponents = lineText.componentsSeparatedByString(":")
                if headerComponents.count == 2 {
                    headers[headerComponents[0]] = headerComponents[1]
                }
            }
            
            // Look for form data. TODO: Same as above. Can form data contain equal signs? Maybe split on the first one?
            if lineText.containsString("=") {
                let formDataComponents = lineText.componentsSeparatedByString("=")
                if formDataComponents.count == 2 {
                    formData[formDataComponents[0]] = formDataComponents[1]
                }
            }
        }

    }

    // MARK: - Sending
    
    var response: NSURLResponse?
    var bodyData: NSData?

}