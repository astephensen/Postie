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
    static func send(_ request: Request, updated: @escaping (_ request: Request) -> Void) {
        guard let requestURL = request.url else {
            return
        }
        guard let method = request.method else {
            return
        }
        
        // Create the request and set the method.
        var urlRequest = URLRequest(url: requestURL)
        urlRequest.httpMethod = method
        
        // Set the headers.
        for (header, value) in request.headers {
            urlRequest.setValue(value, forHTTPHeaderField: header)
        }
        
        // Set form data.
        if request.formData.count > 0 {
            try! urlRequest = URLEncoding.default.encode(urlRequest, with: request.formData)
        }
        
        // Set the body data.
        if let bodyJSON = request.bodyJSON {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = try! JSONSerialization.data(withJSONObject: bodyJSON, options: [])
        }
        
        // Send the request.
        weak var weakRequest = request
        Alamofire.request(urlRequest).response { response in
            if let request = weakRequest {
                request.response = response.response
                request.bodyData = response.data
                updated(request)
            }
        }
    }
}
