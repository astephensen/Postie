//
//  EditorViewController.swift
//  Postie
//
//  Created by Alan Stephensen on 6/12/2015.
//  Copyright © 2015 Alan Stephensen. All rights reserved.
//

import Cocoa
import CodeView

protocol EditorViewControllerDelegate {
    func editorViewController(sender: EditorViewController, didChangeCursorIndex cursorIndex: Int)
}

class EditorViewController: NSViewController, CodeViewDelegate {
    @IBOutlet var codeView: CodeView!
    var requestPathViewController: RequestPathViewController?
    var delegate: EditorViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupEditor()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func viewWillAppear() {
        super.viewWillAppear()
        loadDocument()
    }

    // MARK: - Functions

    func setupEditor() {
        codeView.delegate = self
        codeView.fragariaView.indentWithSpaces = true
        codeView.fragariaView.minimumGutterWidth = 30
        codeView.fragariaView.gutterBackgroundColour = NSColor(white: 247.0/255.0, alpha: 1.0)
        codeView.fragariaView.gutterDividerDashed = false
        codeView.fragariaView.gutterDividerColour = NSColor(white: 213.0/255.0, alpha: 1.0)
        codeView.fragariaView.textView.textContainerInset = NSSize(width: 0, height: 4)
        codeView.fragariaView.textView.isAutomaticLinkDetectionEnabled = false
    }

    func loadDocument() {
        codeView.fragariaView.string = document.text as NSString
    }

    func updateCursorIndex() {
        let index = codeView.fragariaView.textView.selectedRange.location
        delegate?.editorViewController(sender: self, didChangeCursorIndex: index)
    }

    // MARK: - NSTextDelegate

    func textDidChange(_ notification: Notification) {
        document.text = codeView.fragariaView.string as String
        // Need to update the cursor index so that the newly built requests are used.
        // Hopefully this can be improved someday.
        updateCursorIndex()
    }

    func textViewDidChangeSelection(_ notification: Notification) {
        updateCursorIndex()
    }

    // MARK: - UIStoryboard

    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if segue.identifier == "EmbedRequestPathViewController" {
            requestPathViewController = segue.destinationController as? RequestPathViewController
        }
    }
}
