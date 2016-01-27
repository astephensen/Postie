//
//  AppState.swift
//  Restly
//
//  Created by Alan Stephensen on 27/01/2016.
//  Copyright © 2016 Alan Stephensen. All rights reserved.
//

import Foundation
import ReSwift

struct AppState: StateType {
    var text: String
    var requests: [Request]
    var requestRanges: [NSRange]
    
    // TODO: Maybe this shouldn't exist in the state? Or maybe it should?
    func requestAtLocation(location: Int) -> Request? {
        for (index, range) in requestRanges.enumerate() {
            if NSLocationInRange(location, range) {
                return requests[index]
            }
        }
        return nil
    }
}