//
//  PrettyPrinter.swift
//  Restly
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
    static func prettyPrint(text: String, MIMEType: String) -> String {
        switch MIMEType {
        case "application/json":
            do {
                // Convert the JSON to an object and convert back to pretty text. If it fails return the text. Not pretty, but it works.
                let JSONObject = try NSJSONSerialization.JSONObjectWithData(text.dataUsingEncoding(NSUTF8StringEncoding)!, options: [])
                let prettyData = try NSJSONSerialization.dataWithJSONObject(JSONObject, options: .PrettyPrinted)
                if let prettyText = String(data: prettyData, encoding: NSUTF8StringEncoding) {
                    return prettyText
                }
            } catch {
                print("Could not create JSON object.")
            }
            return text
        default:
            return text
        }
    }
}
