//
//  ResultsViewController.swift
//  Restly
//
//  Created by Alan Stephensen on 24/01/2016.
//  Copyright © 2016 Alan Stephensen. All rights reserved.
//

import Cocoa

class ResultsViewController: NSViewController, NSTabViewDelegate {
    @IBOutlet var bottomBorder: NSView?
    @IBOutlet var requestTabButton: NSButton?
    @IBOutlet var responseTabButton: NSButton?
    @IBOutlet var dataTabButton: NSButton?
    var tabImages = [
        "tab-request",
        "tab-response",
        "tab-data"
    ]
    var resultsTabViewController: ResultsTabViewController?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup background and border.
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor(white: 247.0/255.0, alpha: 1.0).CGColor
        bottomBorder?.wantsLayer = true
        bottomBorder?.layer?.backgroundColor = NSColor(white: 213.0/255.0, alpha: 1.0).CGColor
    }
    
    // MARK: - Actions
    
    @IBAction func switchTab(sender: NSButton) {
        switch sender {
        case requestTabButton!:
            resultsTabViewController?.selectedTabViewItemIndex = 0
        case responseTabButton!:
            resultsTabViewController?.selectedTabViewItemIndex = 1
        case dataTabButton!:
            resultsTabViewController?.selectedTabViewItemIndex = 2
        default:
            break
        }
        
    }
    
    // MARK: - Storyboard
    
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        if let destination = segue.destinationController as? ResultsTabViewController {
            resultsTabViewController = destination
            resultsTabViewController?.tabView.delegate = self
        }
    }
    
    // MARK: - NSTabViewDelegate
    
    func tabView(tabView: NSTabView, didSelectTabViewItem tabViewItem: NSTabViewItem?) {
        requestTabButton?.image = NSImage(named: "tab-request")
        responseTabButton?.image = NSImage(named: "tab-response")
        dataTabButton?.image = NSImage(named: "tab-data")
        for (tabIndex, tabButton) in [requestTabButton!, responseTabButton!, dataTabButton].enumerate() {
            tabButton?.image = NSImage(named: tabImages[tabIndex])
            tabButton?.alternateImage = NSImage(named: "\(tabImages[tabIndex])-pressed")
            if tabView.tabViewItems.indexOf(tabViewItem!) == tabIndex {
                tabButton?.image = NSImage(named: "\(tabImages[tabIndex])-selected")
            }
        }
    }
    
}
