//
//  Document.swift
//  Restly
//
//  Created by Alan Stephensen on 8/11/2015.
//  Copyright © 2015 Alan Stephensen. All rights reserved.
//

import Cocoa

class Document: NSDocument {
    var text: String = "" {
        didSet {
            updateRequests()
        }
    }
    var requests = [Request]()
    var documentWindowController: DocumentWindowController?

    override init() {
        super.init()
        // Add your subclass-specific initialization here.
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
            self.addWindowController(documentWindowController)   
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
        
    }

}

