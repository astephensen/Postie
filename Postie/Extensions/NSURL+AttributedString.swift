//
//  NSURL+AttributedString.swift
//  Postie
//
//  Created by Alan Stephensen on 2/01/2016.
//  Copyright © 2016 Alan Stephensen. All rights reserved.
//

import Cocoa

extension URL {
    
    // The colours that should be used.
    struct AttributedStringColours {
        static var scheme = NSColor(white: 0.5, alpha: 1.0)
        static var primary = NSColor(white: 0.1, alpha: 1.0)
        static var secondary = NSColor(white: 0.5, alpha: 1.0)
    }
    
    // Returns an attributed string.
    var attributedString: NSAttributedString {
        let attributedString = NSMutableAttributedString()
        
        attributedString.append(formattedString(scheme, colour: AttributedStringColours.scheme))
        attributedString.append(formattedString("://", colour: AttributedStringColours.secondary))
        attributedString.append(formattedString(user, colour: AttributedStringColours.secondary))
        if password != nil {
            attributedString.append(formattedString(":", colour: AttributedStringColours.secondary))
            attributedString.append(formattedString(password, colour: AttributedStringColours.secondary))
            attributedString.append(formattedString("@", colour: AttributedStringColours.secondary))
        }
        attributedString.append(formattedString(host, colour: AttributedStringColours.primary))
        if port != nil {
            attributedString.append(formattedString(":", colour: AttributedStringColours.secondary))
            // FIXME
            // attributedString.append(formattedString(port?.stringValue, colour: AttributedStringColours.secondary))
        }
        attributedString.append(formattedString(path, colour: AttributedStringColours.secondary))
        attributedString.append(formattedString(pathExtension, colour: AttributedStringColours.secondary))
        attributedString.append(formattedString(path, colour: AttributedStringColours.secondary))
        if query != nil {
            attributedString.append(formattedString("?", colour: AttributedStringColours.secondary))
            attributedString.append(formattedString(query, colour: AttributedStringColours.secondary))
        }
        attributedString.append(formattedString(fragment, colour: AttributedStringColours.secondary))
        
        // Set a paragraph style across the whole string to truncate.
        let paragraphStyle = NSParagraphStyle.default().mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = .byTruncatingTail
        attributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        
        return attributedString
    }
    
    func formattedString(_ string: String?, colour: NSColor) -> NSAttributedString {
        if let string = string {
            return NSAttributedString(string: string, attributes: [
                NSForegroundColorAttributeName: colour,
                NSFontAttributeName: NSFont.systemFont(ofSize: 12.0)
            ])
        }
        return NSAttributedString()
    }
}
