//
//  MainWindowController.swift
//  Restly
//
//  Created by Alan Stephensen on 5/12/2015.
//  Copyright © 2015 Alan Stephensen. All rights reserved.
//

import Cocoa
import ReSwift

class DocumentWindowController: NSWindowController, NSWindowDelegate, StoreSubscriber {
    var currentDocument: Document? {
        // When the document has been set then dispatch an action to update the state.
        didSet {
            mainStore.dispatch(UpdateTextAction(text: currentDocument!.text))
        }
    }
    var mainViewController: MainViewController?
    var requestSender: RequestSender?
    
    // Create the default store with a fresh state.
    var mainStore = Store<AppState>(
        reducer: CombinedReducer([
            AppReducer(),
            RequestReducer(),
            SendingReducer(),
            TextReducer()
        ]),
        state: AppState()
    )

    override func windowDidLoad() {
        super.windowDidLoad()
    
        window?.titleVisibility = .Hidden
        window?.delegate = self
        mainViewController = self.contentViewController as? MainViewController

        // Make the window content view clip subviews. This ensures the bottom corners stay rounded.
        window?.contentView?.wantsLayer = true
        window?.contentView?.layer?.masksToBounds = true
        
        requestSender = RequestSender(store: mainStore)
        mainStore.subscribe(self)
        mainStore.subscribe(requestSender!)
    }
    
    // MARK: - ReSwift
    
    func newState(state: HasTextState) {
        currentDocument?.text = state.textState.text
    }
    
    // MARK: - Methods
    
    func togglePanel(index: Int) {
        if let splitViewItem = mainViewController?.splitViewItems[index] {
            splitViewItem.collapsed = !splitViewItem.collapsed
        }
    }
    
    // MARK: - Actions
    
    @IBAction func panelsToggled(sender: NSSegmentedControl?) {
        if let segmentedControl = sender {
            var selectedSegment = segmentedControl.selectedSegment
            if selectedSegment == 1 {
                selectedSegment = 2
            }
            togglePanel(selectedSegment)
        }
    }
    
    @IBAction func sendRequest(sender: NSToolbarItem?) {
        if let request = mainStore.state.requestState.selectedRequest {
            mainStore.dispatch(SendRequestAction(request: request))
        }
    }
    
    // MARK: - NSWindowDelegate
    
    func windowWillClose(notification: NSNotification) {
        mainStore.unsubscribe(self)
        mainStore.unsubscribe(requestSender!)
    }

}
