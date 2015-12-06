//
//  MainWindowController.swift
//  Restly
//
//  Created by Alan Stephensen on 5/12/2015.
//  Copyright © 2015 Alan Stephensen. All rights reserved.
//

import Cocoa

class DocumentWindowController: NSWindowController {
    var mainViewController: MainViewController?

    override func windowDidLoad() {
        super.windowDidLoad()
    
        window?.titleVisibility = .Hidden
        mainViewController = self.contentViewController as? MainViewController
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

}
