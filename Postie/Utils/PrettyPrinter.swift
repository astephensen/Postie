//
//  PrettyPrinter.swift
//  Postie
//
//  Created by Alan Stephensen on 10/02/2016.
//  Copyright © 2016 Alan Stephensen. All rights reserved.
//

import Cocoa

struct PrettyPrinter {
    
    /// Pretty print text using a MIME type.
    ///
    /// - Parameter text: The text to format.
    /// - Parameter MIMEType: The MIME type of the text.
    ///
    /// - Returns: A new string that has been pretty printed.
    static func prettyPrint(_ text: String, MIMEType: String) -> String {
        switch MIMEType {
        // Process JSON using python.
        case "application/json":
            let command = "python -c 'import json; print(json.dumps(\(text), sort_keys=False, indent=2))'"
            if let prettyText = callSystemCommand(command) {
                return prettyText
            }
            return text
        // Process XML using xmllint.
        case "application/xml": fallthrough
        case "text/xml":
            return text
        // Process HTML using tidy.
        case "text/html":
            return text
        default:
            return text
        }
    }
    
    /// Calls a system command with the passed in text.
    ///
    /// - Parameter command: The command to execute.
    ///
    /// - Returns: An optional string with the result of the command.
    fileprivate static func callSystemCommand(_ command: String) -> String? {
        // Create the task and pipe to execute the command.
        let task = Process()
        task.launchPath = "/bin/sh"
        task.arguments = ["-c", command]
        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
        
        // Read the output from the command.
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: String.Encoding.utf8)
        return output
    }
}
