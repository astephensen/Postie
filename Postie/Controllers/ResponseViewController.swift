//
//  ResponseViewController.swift
//  Postie
//
//  Created by Alan Stephensen on 6/03/2016.
//  Copyright © 2016 Alan Stephensen. All rights reserved.
//

import Cocoa

class ResponseViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    var selectedRequest: Request? {
        didSet {
            tableView?.reloadData()
        }
    }
    @IBOutlet var tableView: NSTableView?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.intercellSpacing = NSSize(width: 0, height: 0)
        // Register cell nibs.
        let tableHeaderCellViewNib = NSNib(nibNamed: "TableHeaderCellView", bundle: Bundle.main)
        tableView?.register(tableHeaderCellViewNib, forIdentifier: "TableHeaderCellView")
        let tableNameValueCellViewNib = NSNib(nibNamed: "TableNameValueCellView", bundle: Bundle.main)
        tableView?.register(tableNameValueCellViewNib, forIdentifier: "TableNameValueCellView")
    }
    
    // MARK: - Functions
    
    func requestChanged(_ request: Request) {
        if request === selectedRequest {
            tableView?.reloadData()
        }
    }
    
    // MARK: - NSTableViewDataSource
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        var headerCount = 0
        if let allHeaders = selectedRequest?.response?.allHeaderFields {
            headerCount = allHeaders.count
        }
        return 2 + headerCount
    }
    
    // MARK: - NSTableViewDelegate
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        // Headers header cell view.
        if row == 0 {
            let headerCellView = tableView.make(withIdentifier: "TableHeaderCellView", owner: self) as? TableHeaderCellView
            headerCellView?.headerLabel?.stringValue = "Headers"
            return headerCellView
        }
        // Header values.
        let nameValueCellView = tableView.make(withIdentifier: "TableNameValueCellView", owner: self) as? TableNameValueCellView
        if row == 1 {
            nameValueCellView?.titleCell = true
            nameValueCellView?.nameLabel?.stringValue = "Name"
            nameValueCellView?.valueLabel?.stringValue = "Value"
        } else {
            // FIXME
            // nameValueCellView?.alternateRow = Bool(row % 2)
            if let header = selectedRequest?.responseHeaders[row - 2] {
                nameValueCellView?.nameLabel?.stringValue = header.name
                nameValueCellView?.valueLabel?.stringValue = header.value
            }
        }
        return nameValueCellView
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 28.0
    }
    
    func tableView(_ tableView: NSTableView, isGroupRow row: Int) -> Bool {
        if row == 0 {
            return true
        }
        return false
    }
    
    // MARK: Selection
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        return row >= 2
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        // Copy header to the clipboard for now.
        if let selectedRow = tableView?.selectedRow {
            if let (name, value) = selectedRequest?.responseHeaders[selectedRow - 2] {
                let pasteboard = NSPasteboard.general()
                pasteboard.clearContents()
                pasteboard.writeObjects(["\(name): \(value)" as NSPasteboardWriting])
            }
        }
    }
    
}
