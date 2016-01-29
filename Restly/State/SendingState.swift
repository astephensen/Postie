//
//  SendingState.swift
//  Restly
//
//  Created by Alan Stephensen on 29/01/2016.
//  Copyright © 2016 Alan Stephensen. All rights reserved.
//

import Foundation
import ReSwift

struct SentRequest {
    var request: Request
    var sending = false
    var progress = 0
}

struct SendingState {
    var sentRequests: [SentRequest] = []
}

protocol HasSendingState {
    var sendingState: SendingState { get set }
}