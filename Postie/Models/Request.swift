//
//  Request.swift
//  Postie
//
//  Created by Alan Stephensen on 5/12/2015.
//  Copyright © 2015 Alan Stephensen. All rights reserved.
//

import Foundation
import Alamofire

/// Notification sent when a request has finished sending.
let RequestFinishedSendingNotification = "RequestFinishedSendingNotification"

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
    var bodyText: String?
    
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
        // - A request does not need to contain a scheme, http:// will be provided by default.
        // - A request can have a port as the start address, localhost will be provided by default.
        if let requestText = requestText {
            let methodDividerRange = requestText.rangeOfString(" ")
            if methodDividerRange.location == NSNotFound {
                // No divider means we'll treat the whole line as the method.
                method = requestText as String
            } else {
                // The method is the first bit, the url string is whatever follows.
                method = requestText.substringToIndex(methodDividerRange.location) as String
                urlString = requestText.substringFromIndex(methodDividerRange.location + 1).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                if var urlString = urlString {
                    // A 'port only' address will require a localhost prefix
                    if urlString.hasPrefix(":") {
                        urlString = "localhost\(urlString)"
                    }
                    // Provide a scheme automatically if the URL does not start with one.
                    if !urlString.containsString("://") {
                        urlString = "http://\(urlString)"
                    }
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
            var processedLine = false
            
            // Look for headers. TODO: Can this handle colons elsewhere? Do headers even have other colons?
            if !processedLine && lineText.containsString(":") && !lineText.hasPrefix("{") {
                let headerComponents = lineText.componentsSeparatedByString(":")
                if headerComponents.count == 2 {
                    let header = headerComponents[0].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                    let value = headerComponents[1].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                    headers[header] = value
                    processedLine = true
                }
            }
            
            // Look for form data. TODO: Same as above. Can form data contain equal signs? Maybe split on the first one?
            if !processedLine && lineText.containsString("=") {
                let formDataComponents = lineText.componentsSeparatedByString("=")
                if formDataComponents.count == 2 {
                    let key = formDataComponents[0].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                    let value = formDataComponents[1].stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                    formData[key] = value
                    processedLine = true
                }
            }
            
            // The line doesn't contain any special data, the remaining text will be treated as body data.
            if !processedLine {
                let processedText = lineText + text.substringFromIndex(text.startIndex.advancedBy(scanner.scanLocation))
                
                // Check if it is JSON. TODO: Should we bother with this?
                if processedText.hasPrefix("{") || processedText.hasPrefix("[") {
                    do {
                        let data = processedText.dataUsingEncoding(NSUTF8StringEncoding)
                        let parsedJSON = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                        bodyJSON = parsedJSON
                    } catch { }
                }
                
                // Finished processing the request text.
                bodyText = processedText
                return
            }
        }
    }

    // MARK: - Sending
    
    var response: NSHTTPURLResponse? {
        didSet {
            responseHeaders.removeAll()
            if let allHeaderFields = response?.allHeaderFields {
                for (name, value) in allHeaderFields {
                    guard let nameString = name as? String else {
                        return
                    }
                    guard let valueString = value as? String else {
                        return
                    }
                    responseHeaders.append((name: nameString, value: valueString))
                }
            }
            // Sort the response headers.
            responseHeaders.sortInPlace { (firstHeader, secondHeader) -> Bool in
                return firstHeader.name < secondHeader.name
            }
        }
    }
    var responseHeaders: [(name: String, value: String)] = []
    var bodyData: NSData?
    
}