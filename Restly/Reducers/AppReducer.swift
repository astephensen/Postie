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
                text: ""
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
    return state
}
