//
//  MainWindowController.swift
//  Postie
//
//  Created by Alan Stephensen on 5/12/2015.
//  Copyright © 2015 Alan Stephensen. All rights reserved.
//

import Cocoa

class DocumentWindowController: NSWindowController, NSWindowDelegate {
    var currentDocument: Document?
    var mainViewController: MainViewController?

    override func windowDidLoad() {
        super.windowDidLoad()
    
        window?.titleVisibility = .Hidden
        window?.delegate = self
        mainViewController = self.contentViewController as? MainViewController

        // Make the window content view clip subviews. This ensures the bottom corners stay rounded.
        window?.contentView?.wantsLayer = true
        window?.contentView?.layer?.masksToBounds = true
    }
    
    // MARK: - Methods
    
    func togglePanel(index: Int) {
        if let splitViewItem = mainViewController?.splitViewItems[index] {
            splitViewItem.collapsed = !splitViewItem.collapsed
        }
    }
    
    // MARK: - Actions
    
    @IBAction func panelsToggled(sender: NSSegmentedControl?) {
        if let segmentedControl = sender {
            var selectedSegment = segmentedControl.selectedSegment
            if selectedSegment == 1 {
                selectedSegment = 2
            }
            togglePanel(selectedSegment)
        }
    }
    
    @IBAction func sendRequest(sender: NSToolbarItem?) {
        if let request = currentDocument?.selectedRequest {
            request.send()
        }
    }
}
