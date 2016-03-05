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
    var selectedRequest: Request? {
        didSet {
            loadRequestBody()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        codeMirrorView?.delegate = self
        codeMirrorView?.readOnly = true
    }
    
    override func viewWillAppear() {
        if !codeMirrorViewLoaded {
            codeMirrorView?.prettyPrint = true
            codeMirrorView?.loadEditor()
            codeMirrorViewLoaded = true
        }
    }

    // MARK: - Functions
    
    func requestChanged(request: Request) {
        if request === selectedRequest {
            loadRequestBody()
        }
    }
    
    func loadRequestBody() {
        guard let bodyData = selectedRequest?.bodyData else {
            codeMirrorView?.text = ""
            return
        }
        // Guess encoding of the data to load.
        var bodyString: NSString?
        NSString.stringEncodingForData(bodyData, encodingOptions: nil, convertedString: &bodyString, usedLossyConversion: nil)
        
        // Convert the NSString to a String
        if let bodyString = bodyString as? String {
            // Set the MIME type - this can also be used to pretty print the response.
            if let MIMEType = selectedRequest?.response?.MIMEType {
                codeMirrorView?.mode = MIMEType
            } else {
                codeMirrorView?.mode = "text"
            }
            codeMirrorView?.text = bodyString
        }
    }

}
