//
//  EditorViewController.swift
//  Restly
//
//  Created by Alan Stephensen on 6/12/2015.
//  Copyright © 2015 Alan Stephensen. All rights reserved.
//

import Cocoa

class EditorViewController: NSViewController, CodeMirrorViewDelegate {
    @IBOutlet var codeMirrorView: CodeMirrorView?
    var currentDocument: Document? {
        didSet {
            loadDocument()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        codeMirrorView?.delegate = self
    }
    
    // MARK: - Functions
    
    func loadDocument() {
        // TODO: Set the text in the editor.
    }
    
    // MARK: - CodeMirrorViewDelegate
    
    func codeMirrorViewDidLoad(codeMirrorView: CodeMirrorView) {
        if let text = currentDocument?.text {
            codeMirrorView.setText(text)   
        }
    }
    
    func codeMirrorViewTextDidChange(codeMirrorView: CodeMirrorView) {
        currentDocument?.text = codeMirrorView.getText()
    }
    
}
