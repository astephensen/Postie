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

    override func viewDidLoad() {
        super.viewDidLoad()
        codeMirrorView?.delegate = self
        codeMirrorView?.mode = "restful"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        loadDocument()
    }
    
    // MARK: - Functions
    
    func loadDocument() {
        codeMirrorView?.loadEditor(document.text)
    }
    
    // MARK: - CodeMirrorViewDelegate
    
    func codeMirrorView(codeMirrorView: CodeMirrorView, didChangeCursorLocation cursorLocation: Int) {
        document.selectedRequest = document.requestAtLocation(cursorLocation)
    }
    
    func codeMirrorView(codeMirrorView: CodeMirrorView, didChangeText newText: String) {
        document.text = newText
    }

}
