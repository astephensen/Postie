//
//  EditorViewController.swift
//  Postie
//
//  Created by Alan Stephensen on 6/12/2015.
//  Copyright © 2015 Alan Stephensen. All rights reserved.
//

import Cocoa
import Fragaria

protocol EditorViewControllerDelegate {
    func editorViewController(sender: EditorViewController, didChangeCursorIndex cursorIndex: Int)
}

class EditorViewController: NSViewController, NSTextDelegate, MGSDragOperationDelegate, MGSFragariaTextViewDelegate {
    @IBOutlet var fragariaView: MGSFragariaView?
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
        fragariaView?.textViewDelegate = self
        fragariaView?.indentWithSpaces = true
        fragariaView?.minimumGutterWidth = 30
        fragariaView?.gutterBackgroundColour = NSColor(white: 247.0/255.0, alpha: 1.0)
        fragariaView?.gutterDividerDashed = false
        fragariaView?.gutterDividerColour = NSColor(white: 213.0/255.0, alpha: 1.0)
    }

    func loadDocument() {
        fragariaView?.string = document.text as NSString
    }

    func updateCursorIndex() {
        if let index = fragariaView?.textView.selectedRange.location {
            delegate?.editorViewController(sender: self, didChangeCursorIndex: index)
        }
    }

    // MARK: - NSTextDelegate

    func textDidChange(_ notification: Notification) {
        if let text = fragariaView?.string as? String {
            document.text = text
            // Need to update the cursor index so that the newly built requests are used.
            // Hopefully this can be improved someday.
            updateCursorIndex()
        }
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
