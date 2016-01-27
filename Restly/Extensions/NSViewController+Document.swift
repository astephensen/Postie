//
//  NSViewController+Document.swift
//  Restly
//
//  Created by Alan Stephensen on 27/01/2016.
//  Copyright © 2016 Alan Stephensen. All rights reserved.
//

import Cocoa

extension NSViewController {
    var document: Document? {
        let targetView = view.superview ?? view
        guard let document = targetView.window?.windowController?.document as? Document else {
            return nil
        }
        return document
    }
}