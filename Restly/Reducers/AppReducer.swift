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
            return AppState(
                text: "",
                requests: [],
                requestRanges: []
            )
        }
        switch action {
        case let action as UpdateTextAction:
            return updateText(state, action: action)
        default:
            return state
        }
    }
}

func updateText(var state: AppState, action: UpdateTextAction) -> AppState {
    state.text = action.text
    // Update the request and request ranges.
    let (requests, requestRanges) = Request.requestsFromText(action.text)
    state.requests = requests
    state.requestRanges = requestRanges
    return state
}
