//
//  RequestPathViewController.swift
//  Restly
//
//  Created by Alan Stephensen on 30/01/2016.
//  Copyright © 2016 Alan Stephensen. All rights reserved.
//

import Cocoa

class RequestPathViewController: NSViewController {
    @IBOutlet var bottomBorder: NSView?
    @IBOutlet var divider: NSView?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup background, border and divider.
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.whiteColor().CGColor
        bottomBorder?.wantsLayer = true
        bottomBorder?.layer?.backgroundColor = NSColor(white: 213.0/255.0, alpha: 1.0).CGColor
        divider?.wantsLayer = true
        divider?.layer?.backgroundColor = bottomBorder?.layer?.backgroundColor
    }
    
}
