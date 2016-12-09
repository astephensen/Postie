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
    static func sendRequest(_ request: Request, updated: @escaping (_ request: Request) -> Void) {
        weak var weakRequest = request
        guard let requestURL = request.url else {
            return
        }
        guard let method = request.method else {
            return
        }
        
        // Create the request and set the method.
        var urlRequest = NSMutableURLRequest(url: requestURL as URL)
        urlRequest.httpMethod = method
        
        // Set the headers.
        for (header, value) in request.headers {
            urlRequest.setValue(value, forHTTPHeaderField: header)
        }
        
        // Set form data.
        /*
        FIXME
        if request.formData.count > 0 {
            let encoding = Alamofire.ParameterEncoding.url
            (urlRequest, _) = encoding.encode(urlRequest, parameters: request.formData)
        }
        */
        
        // Set the body data.
        if let bodyJSON = request.bodyJSON {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = try! JSONSerialization.data(withJSONObject: bodyJSON, options: [])
        }
        
        // Send the request.
        /*
        FIXME
        Alamofire.request(urlRequest).response { (request, response, data, error) in
            if let request = weakRequest {
                request.response = response
                request.bodyData = data
                updated(request: request)
            }
        }
        */
    }
}
