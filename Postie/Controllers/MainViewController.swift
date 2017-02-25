//
//  MainViewController.swift
//  Postie
//
//  Created by Alan Stephensen on 5/12/2015.
//  Copyright © 2015 Alan Stephensen. All rights reserved.
//

import Cocoa

class MainViewController: NSSplitViewController {
    var editorViewController: EditorViewController? {
        get {
            return splitViewItems[0].viewController as? EditorViewController
        }
    }
    var resultsViewController: ResultsViewController? {
        get {
            return splitViewItems[1].viewController as? ResultsViewController
        }
    }
}
