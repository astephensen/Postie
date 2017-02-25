//
//  MainWindowController.swift
//  Postie
//
//  Created by Alan Stephensen on 5/12/2015.
//  Copyright © 2015 Alan Stephensen. All rights reserved.
//

import Cocoa

class DocumentWindowController: NSWindowController, NSWindowDelegate, EditorViewControllerDelegate {
    var mainViewController: MainViewController?

    override func windowDidLoad() {
        super.windowDidLoad()
        window?.titleVisibility = .hidden
        window?.delegate = self

        // Make the window content view clip subviews. This ensures the bottom corners stay rounded.
        window?.contentView?.wantsLayer = true
        window?.contentView?.layer?.masksToBounds = true
        
        // Setup delegates and references.
        mainViewController = self.contentViewController as? MainViewController
        mainViewController?.editorViewController?.delegate = self
    }
    
    // MARK: - Actions

    @IBAction func sendRequestAction(_ sender: NSToolbarItem?) {
        if let request = selectedRequest {
            sendRequest(request)
        }
    }
    
    // MARK: - Methods

    func sendRequest(_ request: Request) {
        weak var weakMainViewController = mainViewController
        RequestSender.send(request) { request -> Void in
            weakMainViewController?.resultsViewController?.resultsTabViewController?.responseViewController?.requestChanged(request)
            weakMainViewController?.resultsViewController?.resultsTabViewController?.responseDataViewController?.requestChanged(request)
        }
    }
    
    // MARK: - Properties
    
    var currentDocument: Document? {
        didSet {
            if let requests = currentDocument?.requests {
                if requests.count > 0 {
                    selectedRequest = currentDocument?.requests[0]
                }
            }
            text = currentDocument?.text
        }
    }
    
    var selectedRequest: Request? {
        didSet {
            mainViewController?.editorViewController?.requestPathViewController?.selectedRequest = selectedRequest
            mainViewController?.resultsViewController?.resultsTabViewController?.responseViewController?.selectedRequest = selectedRequest
            mainViewController?.resultsViewController?.resultsTabViewController?.responseDataViewController?.selectedRequest = selectedRequest
        }
    }
    
    var text: String?

    // MARK: - EditorViewControllerDelegate

    func editorViewController(sender: EditorViewController, didChangeCursorIndex cursorIndex: Int) {
        selectedRequest = currentDocument?.requestAtLocation(cursorIndex)
    }
}
