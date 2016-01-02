//
//  RequestsListViewController.swift
//  Restly
//
//  Created by Alan Stephensen on 5/12/2015.
//  Copyright © 2015 Alan Stephensen. All rights reserved.
//

import Cocoa

class RequestsListViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    var currentDocument: Document? {
        didSet {
            tableView?.reloadData()
        }
    }
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
        guard currentDocument != nil else {
            return 0
        }
        return currentDocument!.requests.count
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let request = currentDocument?.requests[row] else {
            return nil
        }
        let requestTableCellView = tableView.makeViewWithIdentifier("RequestCell", owner: self) as? RequestTableCellView
        requestTableCellView?.configureForRequest(request)
        return requestTableCellView
    }
    
    // MARK: - Notifications

    func setupNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "documentDidUpdateRequests:", name: DocumentDidUpdateRequestsNotification, object: currentDocument)
    }
    
    func documentDidUpdateRequests(notification: NSNotification) {
        tableView?.reloadData()
    }
    
}
