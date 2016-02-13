//
//  NSViewController+Document.swift
//  Restly
//
//  Created by Alan Stephensen on 13/02/2016.
//  Copyright © 2016 Alan Stephensen. All rights reserved.
//

import Cocoa

extension NSViewController {
    var document: Document {
        // Find the document window controller using the view. Sometimes we need to use the superview of the view for ??? reasons.
        let targetView = view.superview ?? view
        if let documentWindowController = targetView.window?.windowController as? DocumentWindowController {
            if let document = documentWindowController.document as? Document {
                return document
            }
        }
        print("WARNING: Could not access document!")
        return Document()
    }
}