//
//  ResultsTabViewController.swift
//  Postie
//
//  Created by Alan Stephensen on 24/01/2016.
//  Copyright © 2016 Alan Stephensen. All rights reserved.
//

import Cocoa

class ResultsTabViewController: NSTabViewController {
    
    var responseDataViewController: ResponseDataViewController? {
        get {
            return tabViewItems[2].viewController as? ResponseDataViewController
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Hide the tabs.
        self.tabStyle = .Unspecified
    }
    
}
