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
    var requests: [Request]? {
        didSet {
            tableView?.reloadData()
        }
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
        return requests?.count ?? 0
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let request = requests![row]
        let requestTableCellView = tableView.makeViewWithIdentifier("RequestCell", owner: self) as? RequestTableCellView
        requestTableCellView?.configureForRequest(request)
        return requestTableCellView
    }
    
}
