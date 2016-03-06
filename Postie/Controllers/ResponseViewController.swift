//
//  ResponseViewController.swift
//  Postie
//
//  Created by Alan Stephensen on 6/03/2016.
//  Copyright © 2016 Alan Stephensen. All rights reserved.
//

import Cocoa

class ResponseViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    var selectedRequest: Request?
    @IBOutlet var tableView: NSTableView?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.intercellSpacing = NSSize(width: 0, height: 0)
        // Register cell nibs.
        let tableHeaderCellViewNib = NSNib(nibNamed: "TableHeaderCellView", bundle: NSBundle.mainBundle())
        tableView?.registerNib(tableHeaderCellViewNib, forIdentifier: "TableHeaderCellView")
        let tableNameValueCellViewNib = NSNib(nibNamed: "TableNameValueCellView", bundle: NSBundle.mainBundle())
        tableView?.registerNib(tableNameValueCellViewNib, forIdentifier: "TableNameValueCellView")
    }
    
    // MARK: - Functions
    
    func requestChanged(request: Request) {
        if request === selectedRequest {
            tableView?.reloadData()
        }
    }
    
    // MARK: - NSTableViewDataSource
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        var headerCount = 0
        if let allHeaders = selectedRequest?.response?.allHeaderFields {
            headerCount = allHeaders.count
        }
        return 2 + headerCount
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        // Headers header cell view.
        if row == 0 {
            let headerCellView = tableView.makeViewWithIdentifier("TableHeaderCellView", owner: self) as? TableHeaderCellView
            headerCellView?.headerLabel?.stringValue = "Headers"
            return headerCellView
        }
        // Header values.
        let nameValueCellView = tableView.makeViewWithIdentifier("TableNameValueCellView", owner: self) as? TableNameValueCellView
        if row == 1 {
            nameValueCellView?.titleCell = true
            nameValueCellView?.nameLabel?.stringValue = "Name"
            nameValueCellView?.valueLabel?.stringValue = "Value"
        } else {
            nameValueCellView?.alternateRow = Bool(row % 2)
            if let header = selectedRequest?.responseHeaders[row - 2] {
                nameValueCellView?.nameLabel?.stringValue = header.name
                nameValueCellView?.valueLabel?.stringValue = header.value
            }
        }
        return nameValueCellView
    }
    
    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 28.0
    }
    
    // MARK: - NSTableViewDelegate
    
    func tableView(tableView: NSTableView, isGroupRow row: Int) -> Bool {
        if row == 0 {
            return true
        }
        return false
    }
    
}
