//
//  TextState.swift
//  Restly
//
//  Created by Alan Stephensen on 28/01/2016.
//  Copyright © 2016 Alan Stephensen. All rights reserved.
//

import Foundation
import ReSwift

struct TextState {
    var text = ""
    var cursorLocation = 0
}

protocol HasTextState {
    var textState: TextState { get set }
}