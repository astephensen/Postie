//
//  ResponseDataViewController.swift
//  Postie
//
//  Created by Alan Stephensen on 24/01/2016.
//  Copyright © 2016 Alan Stephensen. All rights reserved.
//

import Cocoa
import CodeView

class ResponseDataViewController: NSViewController {
    @IBOutlet var codeView: CodeView?
    var selectedRequest: Request? {
        didSet {
            loadRequestBody()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupEditor()
    }

    // MARK: - Functions

    func setupEditor() {
        codeView?.fragariaView.minimumGutterWidth = 30
        codeView?.fragariaView.textView.isEditable = false
        codeView?.fragariaView.backgroundColor = NSColor(white: 247.0/255.0, alpha: 1.0)
        codeView?.fragariaView.gutterBackgroundColour = NSColor(white: 247.0/255.0, alpha: 1.0)
        codeView?.fragariaView.gutterDividerDashed = false
        codeView?.fragariaView.textView.textContainerInset = NSSize(width: 0, height: 4)
    }
    
    func requestChanged(_ request: Request) {
        if request === selectedRequest {
            loadRequestBody()
        }
    }
    
    func loadRequestBody() {
        guard let bodyData = selectedRequest?.bodyData else {
            codeView?.fragariaView.string = ""
            return
        }
        // Guess encoding of the data to load.
        var bodyString: NSString?
        NSString.stringEncoding(for: bodyData as Data, encodingOptions: nil, convertedString: &bodyString, usedLossyConversion: nil)
        
        // Load the string into the editor.
        if let bodyString = bodyString {
            codeView?.fragariaView.string = bodyString
        }

        // Attempt to set the editor highlight based on the MIME type.
        /*
        if let MIMEType = selectedRequest?.response?.mimeType {
            
        } else {
            
        }
        */
    }

}
