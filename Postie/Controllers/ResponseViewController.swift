//
//  ResponseViewController.swift
//  Postie
//
//  Created by Alan Stephensen on 24/01/2016.
//  Copyright © 2016 Alan Stephensen. All rights reserved.
//

import Cocoa

class ResponseViewController: NSViewController, CodeMirrorViewDelegate {
    @IBOutlet var codeMirrorView: CodeMirrorView?
    var codeMirrorViewLoaded = false
    var currentSelectedRequest: Request?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNotifications()
        codeMirrorView?.delegate = self
        codeMirrorView?.readOnly = true
    }
    
    override func viewWillAppear() {
        if !codeMirrorViewLoaded {
            codeMirrorView?.loadEditor()
            codeMirrorViewLoaded = true
        }
    }
    
    // MARK: - Notifications
    
    func setupNotifications() {
        weak var weakSelf = self
        // Observe when the selected request has changed - reload the request body.
        NSNotificationCenter.defaultCenter().addObserverForName(DocumentDidChangeSelectedRequestNotification, object: nil, queue: nil) { notification in
            weakSelf?.currentSelectedRequest = notification.object as? Request
            weakSelf?.loadRequestBody()
        }
        // Observe when the request has been sent - reload the request body if it's the currently displayed request.
        NSNotificationCenter.defaultCenter().addObserverForName(RequestFinishedSendingNotification, object: nil, queue: nil) { notification in
            if weakSelf?.currentSelectedRequest === notification.object as? Request {
                weakSelf?.loadRequestBody()
            }
        }
    }
    
    // MARK: - Functions
    
    func loadRequestBody() {
        guard let bodyData = currentSelectedRequest?.bodyData else {
            codeMirrorView?.text = ""
            return
        }
        // Guess encoding of the data to load.
        var bodyString: NSString?
        NSString.stringEncodingForData(bodyData, encodingOptions: nil, convertedString: &bodyString, usedLossyConversion: nil)
        
        // Convert the NSString to a String
        if var bodyString = bodyString as? String {
            // Set the MIME type - this can also be used to pretty print the response.
            if let MIMEType = currentSelectedRequest?.response?.MIMEType {
                codeMirrorView?.mode = MIMEType
                bodyString = PrettyPrinter.prettyPrint(bodyString, MIMEType: MIMEType)
            }
            codeMirrorView?.text = bodyString
        }
    }

}
