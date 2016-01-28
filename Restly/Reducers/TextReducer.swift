//
//  TextReducer.swift
//  Restly
//
//  Created by Alan Stephensen on 28/01/2016.
//  Copyright © 2016 Alan Stephensen. All rights reserved.
//

import Foundation
import ReSwift

struct TextReducer: Reducer {
    func handleAction(action: Action, state: HasTextState?) -> HasTextState {
        guard let state = state else {
            assert(false, "State is nil")
        }
        switch action {
        case let action as UpdateTextAction:
            return updateText(state, action: action)
        default:
            return state
        }
    }
}

func updateText(var state: HasTextState, action: UpdateTextAction) -> HasTextState {
    state.textState.text = action.text
    return state
}
