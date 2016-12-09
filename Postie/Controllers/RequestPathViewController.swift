//
//  RequestPathViewController.swift
//  Postie
//
//  Created by Alan Stephensen on 30/01/2016.
//  Copyright © 2016 Alan Stephensen. All rights reserved.
//

import Cocoa

class RequestPathViewController: NSViewController {
    @IBOutlet var bottomBorder: NSView?
    @IBOutlet var divider: NSView?
    @IBOutlet var methodButton: NSButton?
    @IBOutlet var pathControl: NSPathControl?
    var selectedRequest: Request? {
        didSet {
            setupPathForRequest(selectedRequest)
        }
    }
    
    var primaryColour = NSColor(white: 0.1, alpha: 1.0)
    var secondaryColour = NSColor(white: 0.3, alpha: 1.0)
    var tertiaryColour = NSColor(white: 0.5, alpha: 1.0)

    override func viewDidLoad() {
        super.viewDidLoad()
        pathControl?.pathItems = []

        // Setup background, border and divider.
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.white.cgColor
        bottomBorder?.wantsLayer = true
        bottomBorder?.layer?.backgroundColor = NSColor(white: 213.0/255.0, alpha: 1.0).cgColor
        divider?.wantsLayer = true
        divider?.layer?.backgroundColor = bottomBorder?.layer?.backgroundColor
    }
    
    // MARK: - Functions
    
    func setupPathForRequest(_ request: Request?) {
        // Setup method button.
        methodButton?.image = nil
        if let method = request?.method {
            let imageName = "method-\(method.lowercased())"
            methodButton?.image = NSImage(named: imageName)
        }
        // Setup path bar.
        var pathControlItems: [NSPathControlItem] = []
        if let url = request?.url {
            if url.scheme != "" {
                pathControlItems.append(pathControlItemForProperty(url.scheme!, colour: secondaryColour))
            }
            if let user = url.user {
                pathControlItems.append(pathControlItemForProperty(user, colour: tertiaryColour))
            }
            if let password = url.password {
                pathControlItems.append(pathControlItemForProperty(password, colour: tertiaryColour))
            }
            if let host = url.host {
                pathControlItems.append(pathControlItemForProperty(host, colour: primaryColour))
            }
            if let port = (url as NSURL).port?.stringValue {
                pathControlItems.append(pathControlItemForProperty(port, colour: tertiaryColour))
            }
            // FIXME
            /*
            if let pathComponents = url.pathComponents {
                for pathComponent in pathComponents {
                    if pathComponent == "/" {
                        continue
                    }
                    pathControlItems.append(pathControlItemForProperty(pathComponent, colour: tertiaryColour))
                }
            }
            */
            if let query = url.query {
                for queryComponent in query.components(separatedBy: "&") {
                    pathControlItems.append(pathControlItemForProperty(queryComponent, colour: tertiaryColour))
                }
            }
            if let fragment = url.fragment {
                pathControlItems.append(pathControlItemForProperty(fragment, colour: tertiaryColour))
            }
        }
        pathControl?.pathItems = pathControlItems
    }
    
    // Mark: - Helpers
    
    func pathControlItemForProperty(_ property: String, colour: NSColor = NSColor.black) -> NSPathControlItem {
        // We need to word wrap using clipping because NSPathControlItem can't calculate attributed strings properly!
        let paragraphStyle = NSParagraphStyle.default().mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = .byClipping
        let attributes = [
            NSFontAttributeName: NSFont.systemFont(ofSize: 12.0),
            NSParagraphStyleAttributeName: paragraphStyle,
            NSForegroundColorAttributeName: colour
        ]
        // Note: Creating the path item before the attributes dictionary results in a weird exception.
        let pathItem = NSPathControlItem()
        pathItem.attributedTitle = NSMutableAttributedString(string: property, attributes: attributes)
        return pathItem
    }
    
}
