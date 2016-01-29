//
//  RequestSender.swift
//  Restly
//
//  Created by Alan Stephensen on 29/01/2016.
//  Copyright © 2016 Alan Stephensen. All rights reserved.
//

import Alamofire
import Foundation
import ReSwift

class RequestSender: StoreSubscriber {
    var mainStore: Store<AppState>
    
    init(store: Store<AppState>) {
        mainStore = store
    }
    
    // MARK: - ReSwift
    
    /**
     * When the sending state is updated look for any unsent requests that need to be sent.
     */
    func newState(state: HasSendingState) {
        for sentRequest in state.sendingState.sentRequests {
            if !sentRequest.sending {
                sendRequest(sentRequest.request)
            }
        }
    }
    
    // MARK: - Functions
    
    func sendRequest(request: Request) {
        weak var weakSelf = self
        weak var weakRequest = request
        guard let urlAbsoluteString = request.url?.absoluteString else {
            return
        }
        guard let method = request.method else {
            return
        }
        
        Alamofire.request(.fromString(method), urlAbsoluteString).response { (request, response, data, error) in
            if let request = weakRequest, strongSelf = weakSelf {
                request.response = response
                request.bodyData = data
                strongSelf.mainStore.dispatch(RequestFinishedSendingAction(request: request))
            }
        }
    }
}