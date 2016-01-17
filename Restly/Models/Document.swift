//
//  Document.swift
//  Restly
//
//  Created by Alan Stephensen on 8/11/2015.
//  Copyright © 2015 Alan Stephensen. All rights reserved.
//

import Cocoa

let DocumentDidUpdateRequestsNotification = "DocumentDidUpdateRequestsNotification"

class Document: NSDocument {
    var text: String = "" {
        didSet {
            updateRequests()
        }
    }
    var requests = [Request]()
    var documentWindowController: DocumentWindowController?

    init(text: String) {
        super.init()
        
        self.text = text
        self.updateRequests()
    }
    
    override init() {
        super.init()
        self.text = ""
    }

    override func windowControllerDidLoadNib(aController: NSWindowController) {
        super.windowControllerDidLoadNib(aController)
        // Add any code here that needs to be executed once the windowController has loaded the document's window.
    }

    override func makeWindowControllers() {
        // Returns the Storyboard that contains your Document window.
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        documentWindowController = storyboard.instantiateControllerWithIdentifier("DocumentWindowController") as? DocumentWindowController
        if let documentWindowController = documentWindowController {
            documentWindowController.currentDocument = self
            addWindowController(documentWindowController)
        }
    }
    
    // MARK: - Saving / Loading
    
    override class func autosavesInPlace() -> Bool {
        return true
    }

    override func dataOfType(typeName: String) throws -> NSData {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            return data
        }
        // TODO: Handle saving error.
        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
    }

    override func readFromData(data: NSData, ofType typeName: String) throws {
        if let loadedText = NSString(data: data, encoding: NSUTF8StringEncoding) {
            text = loadedText as String
        } else {
            // TODO: Handle loading error.
            throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
        }
    }

    // MARK: - Requests
    
    func updateRequests() {
        // Requests are determined by finding lines that start with a valid request method.
        let methods = ["GET", "PUT", "POST", "PATCH", "DELETE", "HEAD", "OPTIONS", "TRACE", "CONNECT"]
        
        // Create expressions that will be used to match methods.
        let joinedMethods = methods.joinWithSeparator("|")
        let expressionPattern = "^(\(joinedMethods))"
        let methodExpression = try? NSRegularExpression(pattern: expressionPattern, options: .AnchorsMatchLines)
        guard methodExpression != nil else {
            return
        }
        
        // Clear the existing requests array.
        requests.removeAll()
        
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
            }
        }
        
        // Post the notfication that the requests have been updated.
        NSNotificationCenter.defaultCenter().postNotificationName(DocumentDidUpdateRequestsNotification, object: self)
    }
}

