//
//  CodeMirrorView.swift
//  Postie
//
//  Created by Alan Stephensen on 8/11/2015.
//  Copyright © 2015 Alan Stephensen. All rights reserved.
//

import Cocoa
import WebKit

@objc protocol CodeMirrorViewDelegate {
    optional func codeMirrorViewDidLoad(codeMirrorView: CodeMirrorView)
    optional func codeMirrorView(codeMirrorView: CodeMirrorView, didChangeText newText: String)
    optional func codeMirrorView(codeMirrorView: CodeMirrorView, didChangeCursorLocation cursorLocation: Int)
}

class CodeMirrorView: NSView, WKScriptMessageHandler {
    var webView: WKWebView?
    var delegate: CodeMirrorViewDelegate?
    var config: [String: AnyObject] = [
        "lineNumbers": true,
        "styleActiveLine": true,
        "autoCloseBrackets": true,
        "matchBrackets": false,
        "mode": "text",
        "tabSize": 2,
        "autofocus": true
    ]

    override func awakeFromNib() {
        super.awakeFromNib()
        setupWebView()
    }
    
    // MARK: - Setup / Loading
    
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
            // Replace the options with the config object.
            let serialisedConfig = try NSJSONSerialization.dataWithJSONObject(config, options: .PrettyPrinted)
            htmlFile = htmlFile.stringByReplacingOccurrencesOfString("_CONFIG_", withString: String(data: serialisedConfig, encoding: NSUTF8StringEncoding)!)
            // Replace the text to load.
            htmlFile = htmlFile.stringByReplacingOccurrencesOfString("_LOAD_TEXT_", withString: text)
            webView?.loadHTMLString(htmlFile as String!, baseURL: NSURL.fileURLWithPath(bundlePath!))
        } catch {
            
        }
    }
    
    // MARK: - Properties
    
    private var editorText: String? {
        didSet {
            delegate?.codeMirrorView?(self, didChangeText: editorText!)
        }
    }
    
    var text: String? {
        get {
            return editorText
        }
        set(newText) {
            editorText = newText
            // Encode to JSON to pass through to the web view.
            if (newText == nil) {
                return
            }
            do {
                let encodeArray = [newText!]
                let encodedData = try NSJSONSerialization.dataWithJSONObject(encodeArray, options: [])
                let encodedJSON = String(data: encodedData, encoding: NSUTF8StringEncoding)
                let encodedTextRange = encodedJSON!.startIndex.advancedBy(2) ..< encodedJSON!.endIndex.advancedBy(-2)
                let encodedText = encodedJSON?.substringWithRange(encodedTextRange)
                let javascript = "window.editor.doc.setValue(\(prettyPrintText(encodedText!)));"
                webView?.evaluateJavaScript(javascript, completionHandler: nil)
            } catch {}
        }
    }
    
    var cursorLocation = 0 {
        didSet {
            delegate?.codeMirrorView?(self, didChangeCursorLocation: cursorLocation)
        }
    }
    
    var readOnly = false {
        didSet {
            config["readOnly"] = readOnly
            config["cursorBlinkRate"] = readOnly ? -1 : 530
            config["theme"] = readOnly ? "default readonly" : "default"
            config["autofocus"] = readOnly ? false : true
        }
    }
    
    var mode = "text" {
        didSet {
            config["mode"] = mode
            let javascript = "window.editor.setOption('mode', '\(mode)');"
            webView?.evaluateJavaScript(javascript, completionHandler: nil)
        }
    }
    
    var prettyPrint = false {
        didSet {
            text = editorText
        }
    }
    
    // MARK: - Functions

    func prettyPrintText(text: String) -> String {
        if prettyPrint == false {
            return "\"\(text)\""
        }
        switch mode {
        case "application/json":
            return "JSON.stringify(JSON.parse(\"\(text)\"), null, 2)"
        default:
            return "\"\(text)\""
        }
    }

    func updateProperty(property: String, value: AnyObject) {
        switch property {
        case "text":
            if let textValue = value as? String {
                editorText = textValue
            }
        case "cursor":
            if let cursorValue = value as? Int {
                cursorLocation = cursorValue
            }
        default:
            break
        }
    }

    // MARK: - WKScriptMessageHandler
    
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        if let bodyObject = message.body as? [String: AnyObject] {
            if let event = bodyObject["event"] as? String {
                // The event will determine what to do with the body.
                switch event {
                case "updateProperty":
                    guard let property = bodyObject["property"] as? String else {
                        Swift.print("updateProperty event had no property")
                        break
                    }
                    guard let value = bodyObject["value"] as AnyObject! else {
                        Swift.print("updateProperty event had no value")
                        break
                    }
                    updateProperty(property, value: value)
                case "loaded":
                    delegate?.codeMirrorViewDidLoad?(self)
                    webView?.becomeFirstResponder()
                default:
                    break
                }
            }
        }
    }
    
}
