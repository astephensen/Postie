//
//  TableHeaderView.swift
//  Postie
//
//  Created by Alan Stephensen on 6/03/2016.
//  Copyright © 2016 Alan Stephensen. All rights reserved.
//

import Cocoa

class TableHeaderCellView: NSView {
    @IBOutlet var headerLabel: NSTextField?
    @IBOutlet var bottomBorder: NSView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Setup background color and borders.
        wantsLayer = true
        layer?.backgroundColor = NSColor(white: 247.0/255.0, alpha: 1.0).CGColor
        bottomBorder?.wantsLayer = true
        bottomBorder?.layer?.backgroundColor = NSColor(white: 213.0/255.0, alpha: 1.0).CGColor
    }

}
