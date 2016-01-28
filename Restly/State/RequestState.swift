//
//  RequestState.swift
//  Restly
//
//  Created by Alan Stephensen on 28/01/2016.
//  Copyright © 2016 Alan Stephensen. All rights reserved.
//

import Foundation
import ReSwift

struct RequestState {
    var requests: [Request] = []
    var ranges: [NSRange] = []
    
    // TODO: Maybe this shouldn't exist in the state? Or maybe it should?
    func requestAtLocation(location: Int) -> Request? {
        for (index, range) in ranges.enumerate() {
            if NSLocationInRange(location, range) {
                return requests[index]
            }
        }
        return nil
    }
}

protocol HasRequestState {
    var requestState: RequestState { get set }
}