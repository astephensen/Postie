//
//  EditorViewController.swift
//  Postie
//
//  Created by Alan Stephensen on 6/12/2015.
//  Copyright © 2015 Alan Stephensen. All rights reserved.
//

import Cocoa

class EditorViewController: NSViewController, CodeMirrorViewDelegate {
    @IBOutlet var codeMirrorView: CodeMirrorView?
    var requestPathViewController: RequestPathViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    // MARK: - UIStoryboard
    
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EmbedRequestPathViewController" {
            requestPathViewController = segue.destinationController as? RequestPathViewController
        }
    }
}
