//
//  RequestsListViewController.swift
//  Postie
//
//  Created by Alan Stephensen on 5/12/2015.
//  Copyright © 2015 Alan Stephensen. All rights reserved.
//

import Cocoa

class RequestsListViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    @IBOutlet var tableView: NSTableView?
    var requests: [Request]? {
        didSet {
            tableView?.reloadData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        tableView?.backgroundColor = NSColor.clear
        tableView?.selectionHighlightStyle = .sourceList
    }
    
    // MARK: - NSTableViewDelegate
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        tableView?.deselectAll(self)
    }
    
    // MARK: - NSTableViewDataSource
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return requests?.count ?? 0
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let request = requests![row]
        let requestTableCellView = tableView.make(withIdentifier: "RequestCell", owner: self) as? RequestTableCellView
        requestTableCellView?.configureForRequest(request)
        return requestTableCellView
    }
    
}
