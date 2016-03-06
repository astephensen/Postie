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
        return 20
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if row == 0 {
            let headerCellView = tableView.makeViewWithIdentifier("TableHeaderCellView", owner: self)
            return headerCellView
        }
        let nameValueCellView = tableView.makeViewWithIdentifier("TableNameValueCellView", owner: self)
        return nameValueCellView
    }
    
    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 50.0
    }
    
    // MARK: - NSTableViewDelegate
    
    func tableView(tableView: NSTableView, isGroupRow row: Int) -> Bool {
        if row == 0 {
            return true
        }
        return false
    }
    
}
