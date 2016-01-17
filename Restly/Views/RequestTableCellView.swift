//
//  RequestTableCellView.swift
//  Restly
//
//  Created by Alan Stephensen on 2/01/2016.
//  Copyright © 2016 Alan Stephensen. All rights reserved.
//

import Cocoa

class RequestTableCellView: NSTableCellView {
    @IBOutlet var requestIconImageView: NSImageView?
    @IBOutlet var requestTextField: NSTextField?

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
    }
    
    func configureForRequest(request: Request) {
        // Set the URL.
        requestTextField?.stringValue = ""
        if let url = request.url {
            requestTextField?.attributedStringValue = url.attributedString
        }
        
        // Set the method icon.
        if let method = request.method {
            let methodIcon = "method-\(method.lowercaseString)"
            requestIconImageView?.image = NSImage(named: methodIcon)
        }
    }
    
}
