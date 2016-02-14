//
//  RequestsListViewController.swift
//  Postie
//
//  Created by Alan Stephensen on 5/12/2015.
//  Copyright © 2015 Alan Stephensen. All rights reserved.
//

import Cocoa
import ReSwift

class RequestsListViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    @IBOutlet var tableView: NSTableView?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupNotifications()
        tableView?.backgroundColor = NSColor.clearColor()
        tableView?.selectionHighlightStyle = .SourceList
    }
    
    // MARK: - Notifications
    
    func setupNotifications() {
        weak var weakSelf = self
        NSNotificationCenter.defaultCenter().addObserverForName(DocumentDidUpdateRequestsNotification, object: nil, queue: nil) { notification in
            weakSelf?.tableView?.reloadData()
        }
    }
    
    // MARK: - NSTableViewDelegate
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        tableView?.deselectAll(self)
    }
    
    // MARK: - NSTableViewDataSource
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return document.requests.count ?? 0
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let request = document.requests[row]
        let requestTableCellView = tableView.makeViewWithIdentifier("RequestCell", owner: self) as? RequestTableCellView
        requestTableCellView?.configureForRequest(request)
        return requestTableCellView
    }
    
}
