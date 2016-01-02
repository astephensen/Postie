//
//  RequestMethodView.swift
//  Restly
//
//  Created by Alan Stephensen on 2/01/2016.
//  Copyright © 2016 Alan Stephensen. All rights reserved.
//

import Cocoa

@IBDesignable
class RequestMethodView: NSView {
    
    var method = "get"
    
    let requestColours = [
        "get": NSColor(red: 52.0/255.0, green: 152.0/255.0, blue: 219.0/255.0, alpha: 1.0),
        "put": NSColor(red: 230.0/255.0, green: 126.0/255.0, blue: 34.0/255.0, alpha: 1.0),
        "post": NSColor(red: 46.0/255.0, green: 204.0/255.0, blue: 113.0/255.0, alpha: 1.0),
        "patch": NSColor(red: 155.0/255.0, green: 89.0/255.0, blue: 182.0/255.0, alpha: 1.0),
        "delete": NSColor(red: 231.0/255.0, green: 76.0/255.0, blue: 60.0/255.0, alpha: 1.0),
        "head": NSColor(red: 149.0/255.0, green: 165.0/255.0, blue: 166.0/255.0, alpha: 1.0)
    ]

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
        // Work out what colour should be drawn based off the method.
        var methodColour = requestColours[method.lowercaseString]
        if methodColour == nil {
            methodColour = NSColor.redColor()
        }
        methodColour?.setStroke()
        
        // Draw the border. Insetting by 1.5 instead of 0.5 seems to resolve some retina display issues.
        let backgroundFrame = CGRectInset(dirtyRect, 1.5, 1.5)
        let backgroundPath = NSBezierPath(roundedRect: backgroundFrame, xRadius: 5.0, yRadius: 5.0)
        backgroundPath.lineWidth = 0.0
        backgroundPath.flatness = 0
        backgroundPath.stroke()
        
        // Format the method text.
        let methodNSString = method.uppercaseString as NSString
        let methodParagraphStyle = NSParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        methodParagraphStyle.alignment = .Center
        let methodTextFont = NSFont.systemFontOfSize(9.0)
        let methodTextAttributes = [
            NSParagraphStyleAttributeName: methodParagraphStyle,
            NSFontAttributeName: methodTextFont,
            NSForegroundColorAttributeName: methodColour!
        ]
        
        // Adjust the frame to be vertically centered. This is pretty crude, though trying to do it using the font height didn't work reliably.
        let methodTextFrame = CGRectMake(0.0, -4.0, dirtyRect.width, dirtyRect.height)
        methodNSString.drawInRect(methodTextFrame, withAttributes: methodTextAttributes)
    }
    
}
