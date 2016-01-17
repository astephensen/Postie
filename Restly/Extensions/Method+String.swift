//
//  Method+String.swift
//  Restly
//
//  Created by Alan Stephensen on 17/01/2016.
//  Copyright © 2016 Alan Stephensen. All rights reserved.
//

import Alamofire

extension Method {
    static func fromString(method: String) -> Method {
        switch (method) {
        case "OPTIONS": return .OPTIONS
        case "GET": return .GET
        case "HEAD": return .HEAD
        case "POST": return .POST
        case "PUT": return .PUT
        case "PATCH": return .PATCH
        case "DELETE": return .DELETE
        case "TRACE": return .TRACE
        case "CONNECT": return .CONNECT
        default: return .GET
        }
    }
}