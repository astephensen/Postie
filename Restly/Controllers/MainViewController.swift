//
//  MainViewController.swift
//  Restly
//
//  Created by Alan Stephensen on 5/12/2015.
//  Copyright © 2015 Alan Stephensen. All rights reserved.
//

import Cocoa

class MainViewController: NSSplitViewController {
    var requestsListViewController: RequestsListViewController?
    var editorViewController: EditorViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Reference the requests list view controller.
        if let splitViewController = splitViewItems[0].viewController as? RequestsListViewController {
            requestsListViewController = splitViewController
        }
        
        // Reference the editor view controller.
        if let splitViewController = splitViewItems[1].viewController as? EditorViewController {
            editorViewController = splitViewController
        }
    }
    
}
