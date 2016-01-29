//
//  ResponseViewController.swift
//  Restly
//
//  Created by Alan Stephensen on 24/01/2016.
//  Copyright © 2016 Alan Stephensen. All rights reserved.
//

import Cocoa
import ReSwift

class ResponseViewController: NSViewController, CodeMirrorViewDelegate, StoreSubscriber {
    @IBOutlet var codeMirrorView: CodeMirrorView?
    var codeMirrorViewLoaded = false
    var currentSelectedRequest: Request?

    override func viewDidLoad() {
        super.viewDidLoad()
        codeMirrorView?.delegate = self
        codeMirrorView?.readOnly = true
    }
    
    override func viewWillAppear() {
        if !codeMirrorViewLoaded {
            codeMirrorView?.loadEditor()
            codeMirrorViewLoaded = true
        }
        mainStore.subscribe(self)
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        mainStore.unsubscribe(self)
    }
    
    // MARK: - ReSwift
    
    func newState(state: protocol<HasRequestState, HasSendingState>) {
        // Check if the selected request has been updated.
        if state.requestState.selectedRequest !== currentSelectedRequest {
            currentSelectedRequest = state.requestState.selectedRequest
            loadRequestBody()
        }
        // If the current request isn't in the sent requests then assume it has finished and refresh the result. This is a bit shite.
        if !state.sendingState.sentRequests.contains({ sentRequest in return sentRequest.request === currentSelectedRequest }) {
            loadRequestBody()
        }
    }
    
    
    // MARK: - Functions
    
    func loadRequestBody() {
        guard let bodyData = currentSelectedRequest?.bodyData else {
            codeMirrorView?.text = ""
            return
        }
        guard let bodyDataString = String(data: bodyData, encoding: NSUTF8StringEncoding) else {
            codeMirrorView?.text = ""
            return
        }
        codeMirrorView?.text = bodyDataString
    }
    
    // MARK: - CodeMirrorViewDelegate
    
    func codeMirrorViewDidLoad(codeMirrorView: CodeMirrorView) {
    }
    
    func codeMirrorViewTextDidChange(codeMirrorView: CodeMirrorView) {
        
    }
    
}
