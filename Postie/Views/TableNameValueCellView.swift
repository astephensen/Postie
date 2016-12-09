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
    var backgroundColour = NSColor(white: 247.0/255.0, alpha: 1.0).cgColor
    var alternateBackgroundColour = NSColor(white: 250.0/255.0, alpha: 1.0).cgColor
    var titleBackgroundColour = NSColor.white.cgColor
    // Fonts.
    var defaultFont = NSFont.systemFont(ofSize: 11.0)
    var titleFont = NSFont.systemFont(ofSize: 11.0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Setup background color and borders.
        wantsLayer = true
        layer?.backgroundColor = backgroundColour
        bottomBorder?.wantsLayer = true
        bottomBorder?.layer?.backgroundColor = NSColor(white: 213.0/255.0, alpha: 1.0).cgColor
        dividerView?.wantsLayer = true
        dividerView?.layer?.backgroundColor = NSColor(white: 213.0/255.0, alpha: 1.0).cgColor
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
