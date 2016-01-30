//
//  ResultsViewController.swift
//  Restly
//
//  Created by Alan Stephensen on 24/01/2016.
//  Copyright © 2016 Alan Stephensen. All rights reserved.
//

import Cocoa

class ResultsViewController: NSViewController {
    @IBOutlet var bottomBorder: NSView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup background and border.
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor(white: 247.0/255.0, alpha: 1.0).CGColor
        bottomBorder?.wantsLayer = true
        bottomBorder?.layer?.backgroundColor = NSColor(white: 213.0/255.0, alpha: 1.0).CGColor
    }
    
}
