//
//  RequestSender.swift
//  Postie
//
//  Created by Alan Stephensen on 27/02/2016.
//  Copyright © 2016 Alan Stephensen. All rights reserved.
//

import Foundation
import Alamofire

struct RequestSender {
    
    /// Sends a request, calling the closure whenever it has updated.
    ///
    /// - Parameter request: The request to send.
    /// - Parameter updated: The closure to call when sending the request has updated.
    static func sendRequest(request: Request, updated: (request: Request) -> Void) {
        weak var weakRequest = request
        guard let requestURL = request.url else {
            return
        }
        guard let method = request.method else {
            return
        }
        
        // Create the requst
        let urlRequest = NSMutableURLRequest(URL: requestURL)
        urlRequest.HTTPMethod = method
        
        // Set the headers.
        for (header, value) in request.headers {
            urlRequest.setValue(value, forHTTPHeaderField: header)
        }
        
        // Set the body data.
        if let bodyJSON = request.bodyJSON {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(bodyJSON, options: [])
        }
        
        // Send the request.
        Alamofire.request(urlRequest).response { (request, response, data, error) in
            if let request = weakRequest {
                request.response = response
                request.bodyData = data
                updated(request: request)
            }
        }
    }
}