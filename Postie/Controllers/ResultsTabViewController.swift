//
//  ResultsTabViewController.swift
//  Postie
//
//  Created by Alan Stephensen on 24/01/2016.
//  Copyright © 2016 Alan Stephensen. All rights reserved.
//

import Cocoa

class ResultsTabViewController: NSTabViewController {
    
    var responseViewController: ResponseViewController? {
        get {
            return tabViewItems[2].viewController as? ResponseViewController
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Hide the tabs.
        self.tabStyle = .Unspecified
    }
    
}
