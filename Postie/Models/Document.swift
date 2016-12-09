//
//  Document.swift
//  Postie
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
        updateRequests()
    }
    
    override init() {
        super.init()
        self.text = ""
    }

    override func windowControllerDidLoadNib(_ aController: NSWindowController) {
        super.windowControllerDidLoadNib(aController)
        // Add any code here that needs to be executed once the windowController has loaded the document's window.
    }

    override func makeWindowControllers() {
        // Returns the Storyboard that contains your Document window.
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        documentWindowController = storyboard.instantiateController(withIdentifier: "DocumentWindowController") as? DocumentWindowController
        if let documentWindowController = documentWindowController {
            documentWindowController.currentDocument = self
            addWindowController(documentWindowController)
        }
    }
    
    func updateRequests() {
        (requests, requestRanges) = Request.requestsFromText(text)
    }
    
    // MARK: - Text / Requests
    
    var text: String = "" {
        didSet {
            updateRequests()
        }
    }
    var requests: [Request] = []
    var requestRanges: [NSRange] = []
    var selectedRequest: Request?
    
    /// Returns a request at the specified location.
    ///
    /// - Parameter location: The location of the request to find.
    ///
    /// - Returns: The request if one could be found.
    func requestAtLocation(_ location: Int) -> Request? {
        for (index, range) in requestRanges.enumerated() {
            if NSLocationInRange(location, range) {
                return requests[index]
            }
        }
        // A separate check needs to be done in case the cursor is at the end.
        if let lastRange = requestRanges.last {
            if location == NSMaxRange(lastRange) {
                return requests.last
            }
        }
        return nil
    }
    
    // MARK: - Saving / Loading
    
    override class func autosavesInPlace() -> Bool {
        return true
    }

    override func data(ofType typeName: String) throws -> Data {
        if let data = text.data(using: String.Encoding.utf8) {
            return data
        }
        // TODO: Handle saving error.
        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
    }

    override func read(from data: Data, ofType typeName: String) throws {
        if let loadedText = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
            text = loadedText as String
        } else {
            // TODO: Handle loading error.
            throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
        }
    }
}

