//
//  TableNameValueCellView.swift
//  Postie
//
//  Created by Alan Stephensen on 6/03/2016.
//  Copyright © 2016 Alan Stephensen. All rights reserved.
//

import Cocoa

class TableNameValueCellView: NSView {
    @IBOutlet var dividerView: NSView?
    @IBOutlet var bottomBorder: NSView?
    @IBOutlet var nameLabel: NSTextField?
    @IBOutlet var valueLabel: NSTextField?
    // Colours.
    var backgroundColour = NSColor(white: 247.0/255.0, alpha: 1.0).CGColor
    var alternateBackgroundColour = NSColor(white: 239.0/255.0, alpha: 1.0).CGColor
    var titleBackgroundColour = NSColor.whiteColor().CGColor
    // Fonts.
    var defaultFont = NSFont.systemFontOfSize(12.0)
    var titleFont = NSFont.systemFontOfSize(12.0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Setup background color and borders.
        wantsLayer = true
        layer?.backgroundColor = backgroundColour
        bottomBorder?.wantsLayer = true
        bottomBorder?.layer?.backgroundColor = NSColor(white: 213.0/255.0, alpha: 1.0).CGColor
        dividerView?.wantsLayer = true
        dividerView?.layer?.backgroundColor = NSColor(white: 213.0/255.0, alpha: 1.0).CGColor
    }
    
    var titleCell = false {
        didSet {
            if titleCell {
                layer?.backgroundColor = titleBackgroundColour
                nameLabel?.font = titleFont
                valueLabel?.font = titleFont
            } else {
                layer?.backgroundColor = backgroundColour
                nameLabel?.font = defaultFont
                valueLabel?.font = defaultFont
            }
        }
    }

    var alternateRow = false {
        didSet {
            if alternateRow {
                layer?.backgroundColor = alternateBackgroundColour
            } else {
                layer?.backgroundColor = backgroundColour
            }
        }
    }
}
