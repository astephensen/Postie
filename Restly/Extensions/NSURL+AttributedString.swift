//
//  NSURL+AttributedString.swift
//  Restly
//
//  Created by Alan Stephensen on 2/01/2016.
//  Copyright © 2016 Alan Stephensen. All rights reserved.
//

import Cocoa

extension NSURL {
    
    // The colours that should be used.
    struct AttributedStringColours {
        static var scheme = NSColor(white: 0.5, alpha: 1.0)
        static var primary = NSColor(white: 0.1, alpha: 1.0)
        static var secondary = NSColor(white: 0.5, alpha: 1.0)
    }
    
    // Returns an attributed string.
    var attributedString: NSAttributedString {
        let attributedString = NSMutableAttributedString()
        
        attributedString.appendAttributedString(formattedString(scheme, colour: AttributedStringColours.scheme))
        attributedString.appendAttributedString(formattedString("://", colour: AttributedStringColours.secondary))
        attributedString.appendAttributedString(formattedString(user, colour: AttributedStringColours.secondary))
        if password != nil {
            attributedString.appendAttributedString(formattedString(":", colour: AttributedStringColours.secondary))
            attributedString.appendAttributedString(formattedString(password, colour: AttributedStringColours.secondary))
            attributedString.appendAttributedString(formattedString("@", colour: AttributedStringColours.secondary))
        }
        attributedString.appendAttributedString(formattedString(host, colour: AttributedStringColours.primary))
        if port != nil {
            attributedString.appendAttributedString(formattedString(":", colour: AttributedStringColours.secondary))
            attributedString.appendAttributedString(formattedString(port?.stringValue, colour: AttributedStringColours.secondary))
        }
        attributedString.appendAttributedString(formattedString(path, colour: AttributedStringColours.secondary))
        attributedString.appendAttributedString(formattedString(pathExtension, colour: AttributedStringColours.secondary))
        attributedString.appendAttributedString(formattedString(parameterString, colour: AttributedStringColours.secondary))
        if query != nil {
            attributedString.appendAttributedString(formattedString("?", colour: AttributedStringColours.secondary))
            attributedString.appendAttributedString(formattedString(query, colour: AttributedStringColours.secondary))
        }
        attributedString.appendAttributedString(formattedString(fragment, colour: AttributedStringColours.secondary))
        
        // Set a paragraph style across the whole string to truncate.
        let paragraphStyle = NSParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = .ByTruncatingTail
        attributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        
        return attributedString
    }
    
    func formattedString(string: String?, colour: NSColor) -> NSAttributedString {
        if let string = string {
            return NSAttributedString(string: string, attributes: [
                NSForegroundColorAttributeName: colour,
                NSFontAttributeName: NSFont.systemFontOfSize(12.0)
            ])
        }
        return NSAttributedString()
    }
}