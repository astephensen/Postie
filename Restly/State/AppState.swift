//
//  AppState.swift
//  Restly
//
//  Created by Alan Stephensen on 27/01/2016.
//  Copyright © 2016 Alan Stephensen. All rights reserved.
//

import Foundation
import ReSwift

struct AppState: StateType, HasRequestState, HasSendingState, HasTextState {
    var requestState = RequestState()
    var sendingState = SendingState()
    var textState = TextState()
}