//
//  CodeMirrorView.swift
//  Restly
//
//  Created by Alan Stephensen on 8/11/2015.
//  Copyright © 2015 Alan Stephensen. All rights reserved.
//

import Cocoa
import WebKit

class CodeMirrorView: NSView {
    var webView: WKWebView?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupWebView()
    }
    
    func setupWebView() {
        // Create the web view.
        webView = WKWebView()
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
}
