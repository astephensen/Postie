//
//  CodeMirrorView.swift
//  Restly
//
//  Created by Alan Stephensen on 8/11/2015.
//  Copyright © 2015 Alan Stephensen. All rights reserved.
//

import Cocoa
import WebKit

protocol CodeMirrorViewDelegate {
    func codeMirrorViewDidLoad(codeMirrorView: CodeMirrorView)
    func codeMirrorViewTextDidChange(codeMirrorView: CodeMirrorView)
}

class CodeMirrorView: NSView, WKScriptMessageHandler {
    var webView: WKWebView?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupWebView()
    }
    
    func setupWebView() {
        // Setup script notification handler.
        let userContentController = WKUserContentController()
        userContentController.addScriptMessageHandler(self, name: "notification")
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController
        
        // Create the web view.
        webView = WKWebView(frame: CGRectZero, configuration: configuration)
        webView?.translatesAutoresizingMaskIntoConstraints = false
        addSubview(webView!)
        
        // Add constraints.
        let views = ["webView": webView!]
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[webView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[webView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        
        // View setup is done, load the editor.
        loadEditor()
    }
    
    func loadEditor() {
        let htmlFilePath = NSBundle.mainBundle().pathForResource("CodeMirror", ofType: "html")
        do {
            var htmlFile = try NSString(contentsOfFile: htmlFilePath!, encoding: NSUTF8StringEncoding)
            let bundlePath = NSBundle.mainBundle().pathForResource("CodeMirror", ofType: "bundle")
            // Replace the bundle path in the editor with the real path.
            htmlFile = htmlFile.stringByReplacingOccurrencesOfString("_BUNDLE_PATH_", withString: bundlePath!)
            webView?.loadHTMLString(htmlFile as String!, baseURL: NSURL.fileURLWithPath(bundlePath!))
        } catch {
            
        }
    }
    
    // MARK: - Functions
    
    
    // MARK: - WKScriptMessageHandler
    
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        Swift.print(message.body)
    }
    
}
