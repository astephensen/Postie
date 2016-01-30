//
//  RequestPathViewController.swift
//  Restly
//
//  Created by Alan Stephensen on 30/01/2016.
//  Copyright © 2016 Alan Stephensen. All rights reserved.
//

import Cocoa
import ReSwift

class RequestPathViewController: NSViewController, StoreSubscriber {
    @IBOutlet var bottomBorder: NSView?
    @IBOutlet var divider: NSView?
    @IBOutlet var methodButton: NSButton?
    @IBOutlet var pathControl: NSPathControl?
    var selectedRequest: Request? {
        didSet {
            setupPathForRequest(selectedRequest)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        pathControl?.pathItems = []

        // Setup background, border and divider.
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.whiteColor().CGColor
        bottomBorder?.wantsLayer = true
        bottomBorder?.layer?.backgroundColor = NSColor(white: 213.0/255.0, alpha: 1.0).CGColor
        divider?.wantsLayer = true
        divider?.layer?.backgroundColor = bottomBorder?.layer?.backgroundColor
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        mainStore.subscribe(self)
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        mainStore.unsubscribe(self)
    }
    
    // MARK: - Functions
    
    func setupPathForRequest(request: Request?) {
        // Setup method button.
        methodButton?.image = nil
        if let method = request?.method {
            let imageName = "method-\(method.lowercaseString)"
            methodButton?.image = NSImage(named: imageName)
        }
        // Setup path bar.
        var pathControlItems: [NSPathControlItem] = []
        if let url = request?.url {
            pathControlItems.append(pathControlItemForProperty(url.scheme))
            if let user = url.user {
                pathControlItems.append(pathControlItemForProperty(user))
            }
            if let password = url.password {
                pathControlItems.append(pathControlItemForProperty(password))
            }
            if let host = url.host {
                pathControlItems.append(pathControlItemForProperty(host))
            }
            if let port = url.port?.stringValue {
                pathControlItems.append(pathControlItemForProperty(port))
            }
            if let pathComponents = url.pathComponents {
                for pathComponent in pathComponents {
                    if pathComponent == "/" {
                        continue
                    }
                    pathControlItems.append(pathControlItemForProperty(pathComponent))
                }
            }
            if let query = url.query {
                for queryComponent in query.componentsSeparatedByString("&") {
                    pathControlItems.append(pathControlItemForProperty(queryComponent))
                }
            }
            if let fragment = url.fragment {
                pathControlItems.append(pathControlItemForProperty(fragment))
            }
        }
        pathControl?.pathItems = pathControlItems
    }
    
    // MARK: - ReSwift
    
    func newState(state: HasRequestState) {
        if state.requestState.selectedRequest !== selectedRequest {
            selectedRequest = state.requestState.selectedRequest
        }
    }
    
    // Mark: - Helpers
    
    func pathControlItemForProperty(property: String) -> NSPathControlItem {
        let pathItem = NSPathControlItem()
        pathItem.title = property
        return pathItem
    }
    
}
