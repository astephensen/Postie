//
//  Document.swift
//  Restly
//
//  Created by Alan Stephensen on 8/11/2015.
//  Copyright © 2015 Alan Stephensen. All rights reserved.
//

import Cocoa

/// Notification sent whenever the requests for the document has been updated.
let DocumentDidUpdateRequestsNotification = "DocumentDidUpdateRequestsNotification"
/// Notification sent whenever the selected request is updated.
let DocumentDidChangeSelectedRequestNotification = "DocumentDidChangeSelectedRequestNotification"

class Document: NSDocument {
    var documentWindowController: DocumentWindowController?

    init(text: String) {
        super.init()
        self.text = text
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
    
    // MARK: - Text / Requests
    
    var text: String = "" {
        didSet {
            (requests, requestRanges) = Request.requestsFromText(text)
            NSNotificationCenter.defaultCenter().postNotificationName(DocumentDidUpdateRequestsNotification, object: nil)
        }
    }
    var requests: [Request] = []
    var requestRanges: [NSRange] = []
    var selectedRequest: Request? {
        didSet {
            NSNotificationCenter.defaultCenter().postNotificationName(DocumentDidChangeSelectedRequestNotification, object: selectedRequest)
        }
    }
    
    /// Returns a request at the specified location.
    ///
    /// - Parameter location: The location of the request to find.
    ///
    /// - Returns: The request if one could be found.
    func requestAtLocation(location: Int) -> Request? {
        for (index, range) in requestRanges.enumerate() {
            if NSLocationInRange(location, range) {
                return requests[index]
            }
        }
        return nil
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
    
    // MARK: - Sending Requests
    
    
    
}

