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
        codeMirrorView?.loadEditor(document!.text)
    }
    
    // MARK: - CodeMirrorViewDelegate
    
    func codeMirrorViewDidLoad(codeMirrorView: CodeMirrorView) {

    }
    
    func codeMirrorViewTextDidChange(codeMirrorView: CodeMirrorView) {
        if let text = codeMirrorView.text {
            document?.text = text
        }
    }
    
}
