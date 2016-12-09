//
//  MainWindowController.swift
//  Postie
//
//  Created by Alan Stephensen on 5/12/2015.
//  Copyright © 2015 Alan Stephensen. All rights reserved.
//

import Cocoa
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class DocumentWindowController: NSWindowController, NSWindowDelegate, CodeMirrorViewDelegate {
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
        mainViewController?.editorViewController?.codeMirrorView?.delegate = self
    }
    
    // MARK: - Actions
    
    @IBAction func panelsToggled(_ sender: NSSegmentedControl?) {
        if let segmentedControl = sender {
            var selectedSegment = segmentedControl.selectedSegment
            if selectedSegment == 1 {
                selectedSegment = 2
            }
            togglePanel(selectedSegment)
        }
    }
    
    @IBAction func sendRequestAction(_ sender: NSToolbarItem?) {
        if let request = selectedRequest {
            sendRequest(request)
        }
    }
    
    // MARK: - Methods
    
    func togglePanel(_ index: Int) {
        if let splitViewItem = mainViewController?.splitViewItems[index] {
            splitViewItem.isCollapsed = !splitViewItem.isCollapsed
        }
    }
    
    func sendRequest(_ request: Request) {
        weak var weakMainViewController = mainViewController
        RequestSender.sendRequest(request) { (request) -> Void in
            weakMainViewController?.resultsViewController?.resultsTabViewController?.responseViewController?.requestChanged(request)
            weakMainViewController?.resultsViewController?.resultsTabViewController?.responseDataViewController?.requestChanged(request)
        }
    }
    
    // MARK: - Properties
    
    var currentDocument: Document? {
        didSet {
            if currentDocument?.requests.count > 0 {
                selectedRequest = currentDocument?.requests[0]
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
    
    var text: String? {
        didSet {
            mainViewController?.requestsListViewController?.requests = currentDocument?.requests
        }
    }
    
    // MARK: - CodeMirrorViewDelegate
    
    func codeMirrorView(_ codeMirrorView: CodeMirrorView, didChangeCursorLocation cursorLocation: Int) {
        selectedRequest = currentDocument?.requestAtLocation(cursorLocation)
    }
    
    func codeMirrorView(_ codeMirrorView: CodeMirrorView, didChangeText newText: String) {
        currentDocument?.text = newText
        text = newText
    }
}
