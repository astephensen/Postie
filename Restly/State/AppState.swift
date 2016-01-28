//
//  AppState.swift
//  Restly
//
//  Created by Alan Stephensen on 27/01/2016.
//  Copyright © 2016 Alan Stephensen. All rights reserved.
//

import Foundation
import ReSwift

struct AppState: StateType, HasTextState, HasRequestState {
    var textState = TextState()
    var requestState = RequestState()
}