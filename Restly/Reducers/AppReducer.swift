//
//  AppReducer.swift
//  Restly
//
//  Created by Alan Stephensen on 27/01/2016.
//  Copyright © 2016 Alan Stephensen. All rights reserved.
//

import Foundation
import ReSwift

struct AppReducer: Reducer {
    func handleAction(action: Action, state: AppState?) -> AppState {
        guard let state = state else {
            assert(false, "State is nil")
        }
        return state
    }
}