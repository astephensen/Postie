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
    var delegate: CodeMirrorViewDelegate?

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
    }
    
    func loadEditor() {
        loadEditor("")
    }
    
    func loadEditor(text: String) {
        let htmlFilePath = NSBundle.mainBundle().pathForResource("CodeMirror", ofType: "html")
        do {
            var htmlFile = try NSString(contentsOfFile: htmlFilePath!, encoding: NSUTF8StringEncoding)
            let bundlePath = NSBundle.mainBundle().pathForResource("CodeMirror", ofType: "bundle")
            // Replace the bundle path in the editor with the real path.
            htmlFile = htmlFile.stringByReplacingOccurrencesOfString("_BUNDLE_PATH_", withString: bundlePath!)
            // Replace the text to load.
            htmlFile = htmlFile.stringByReplacingOccurrencesOfString("_LOAD_TEXT_", withString: text)
            webView?.loadHTMLString(htmlFile as String!, baseURL: NSURL.fileURLWithPath(bundlePath!))
        } catch {
            
        }
    }
    
    // MARK: - Properties
    
    private var editorText: String?
    
    // MARK: - Functions
    
    func getText() -> String {
        if let editorText = editorText {
            return editorText
        }
        return ""
    }
    
    func setText(text: String) {
        editorText = text
        Swift.print(editorText)
        let javascript = "window.editor.doc.setValue('\(text)')"
        webView?.evaluateJavaScript(javascript, completionHandler: nil)
    }
    
    func updateTextProperty() {
        let javascript = "window.editor.doc.getValue()"
        weak var weakSelf = self
        webView?.evaluateJavaScript(javascript, completionHandler: { (result, error) -> Void in
            if let text = result as? String {
                weakSelf?.editorText = text
                weakSelf?.delegate?.codeMirrorViewTextDidChange(self)
            }
        })
    }
    
    // MARK: - Cursors
    // TODO: Update the cursor location
    
    var cursorLocation = 0
    
    // MARK: - WKScriptMessageHandler
    
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        if let bodyObject = message.body as? [String: AnyObject] {
            if let event = bodyObject["event"] as? String {
                // The event will determine what to do with the body.
                switch event {
                case "change":
                    updateTextProperty()
                case "loaded":
                    delegate?.codeMirrorViewDidLoad(self)
                default:
                    break
                }
            }
        }
    }
    
}
