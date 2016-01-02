//
//  RequestTableCellView.swift
//  Restly
//
//  Created by Alan Stephensen on 2/01/2016.
//  Copyright © 2016 Alan Stephensen. All rights reserved.
//

import Cocoa

class RequestTableCellView: NSTableCellView {
    @IBOutlet var requestMethodView: RequestMethodView?

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
    }
    
    func configureForRequest(request: Request) {
        // Set the URL.
        textField?.stringValue = ""
        if let urlString = request.urlString {
            textField?.stringValue = urlString
        }
        
        // Set the method.
        if let method = request.method {
            requestMethodView?.method = method
        }
    }
    
}
