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
    var requests: [[String: String]] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // TODO: This is just temporary.
        requests.append([
            "type": "GET",
            "path": "example.com"
        ])
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
        return requests.count
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let request = requests[row]
        let tableCellView = tableView.makeViewWithIdentifier("RequestCell", owner: self) as? NSTableCellView
        if let path = request["path"] {
            tableCellView?.textField?.stringValue = path
        }
        return tableCellView
    }
    
}
