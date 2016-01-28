//
//  RequestReducer.swift
//  Restly
//
//  Created by Alan Stephensen on 28/01/2016.
//  Copyright © 2016 Alan Stephensen. All rights reserved.
//

import Foundation
import ReSwift

struct RequestReducer: Reducer {
    func handleAction(action: Action, state: HasRequestState?) -> HasRequestState {
        guard let state = state else {
            assert(false, "State is nil")
        }
        switch action {
        case let action as UpdateTextAction:
            return updateRequests(state, action: action)
        case let action as UpdateCursorLocationAction:
            return updateSelectedRequest(state, action: action)
        default:
            return state
        }
    }
}

func updateRequests(var state: HasRequestState, action: UpdateTextAction) -> HasRequestState {
    let (requests, requestRanges) = Request.requestsFromText(action.text)
    state.requestState.requests = requests
    state.requestState.ranges = requestRanges
    return state
}

func updateSelectedRequest(var state: HasRequestState, action: UpdateCursorLocationAction) -> HasRequestState {
    if let request = state.requestState.requestAtLocation(action.location) {
        state.requestState.selectedRequest = request
    }
    return state
}