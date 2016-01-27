//
//  ResponseViewController.swift
//  Restly
//
//  Created by Alan Stephensen on 24/01/2016.
//  Copyright © 2016 Alan Stephensen. All rights reserved.
//

import Cocoa

class ResponseViewController: NSViewController, CodeMirrorViewDelegate {
    @IBOutlet var codeMirrorView: CodeMirrorView?
    var codeMirrorViewLoaded = false

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
    }
    
    // MARK: - CodeMirrorViewDelegate
    
    func codeMirrorViewDidLoad(codeMirrorView: CodeMirrorView) {
    }
    
    func codeMirrorViewTextDidChange(codeMirrorView: CodeMirrorView) {
        
    }
    
}
