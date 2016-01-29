//
//  SendingReducer.swift
//  Restly
//
//  Created by Alan Stephensen on 29/01/2016.
//  Copyright © 2016 Alan Stephensen. All rights reserved.
//

import Foundation
import ReSwift

struct SendingReducer: Reducer {
    func handleAction(action: Action, state: HasSendingState?) -> HasSendingState {
        guard let state = state else {
            assert(false, "State is nil")
        }
        switch action {
        case let action as SendRequestAction:
            return sendRequest(state, action: action)
        case let action as RequestFinishedSendingAction:
            return requestFinishedSending(state, action: action)
        default:
            return state
        }
    }
}

/**
 * A request needs to be sent. Create a new sentRequest object that will be picked up by the request sender.
 */
func sendRequest(var state: HasSendingState, action: SendRequestAction) -> HasSendingState {
    let sentRequest = SentRequest(
        request: action.request,
        sending: false,
        progress: 0
    )
    state.sendingState.sentRequests.append(sentRequest)
    return state
}

/**
 * A request has finished sending. Remove it from the sentRequests array in the state.
 */
func requestFinishedSending(var state: HasSendingState, action: RequestFinishedSendingAction) -> HasSendingState {
    state.sendingState.sentRequests = state.sendingState.sentRequests.filter { sentRequest in
        return sentRequest.request !== action.request
    }
    return state
}