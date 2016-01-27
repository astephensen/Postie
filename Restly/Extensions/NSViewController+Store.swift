//
//  NSViewController+Store.swift
//  Restly
//
//  Created by Alan Stephensen on 27/01/2016.
//  Copyright © 2016 Alan Stephensen. All rights reserved.
//

import Cocoa
import ReSwift

extension NSViewController {
    var mainStore: Store<AppState> {
        // Find the document window controller using the view. Sometimes we need to use the superview of the view for ??? reasons.
        let targetView = view.superview ?? view
        guard let documentWindowController = targetView.window?.windowController as? DocumentWindowController else {
            print("WARNING: Main Store could not be returned!")
            return Store<AppState>(reducer: AppReducer(), state: nil)
        }
        return documentWindowController.mainStore
    }
}