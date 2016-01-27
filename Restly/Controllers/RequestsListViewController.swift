//
//  RequestsListViewController.swift
//  Restly
//
//  Created by Alan Stephensen on 5/12/2015.
//  Copyright © 2015 Alan Stephensen. All rights reserved.
//

import Cocoa

class RequestsListViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    @IBOutlet var tableView: NSTableView?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNotifications()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView?.backgroundColor = NSColor.clearColor()
        tableView?.selectionHighlightStyle = .SourceList
    }
    
    // MARK: - NSTableViewDelegate
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        tableView?.deselectAll(self)
    }
    
    // MARK: - NSTableViewDataSource
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return document?.requests.count ?? 0
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let request = document!.requests[row]
        let requestTableCellView = tableView.makeViewWithIdentifier("RequestCell", owner: self) as? RequestTableCellView
        requestTableCellView?.configureForRequest(request)
        return requestTableCellView
    }
    
    // MARK: - Notifications

    func setupNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "documentDidUpdateRequests:", name: DocumentDidUpdateRequestsNotification, object: nil)
    }
    
    func documentDidUpdateRequests(notification: NSNotification) {
        tableView?.reloadData()
    }
    
}
