//
//  SubscriptionService.swift
//  Quotes
//
//  Created by Цопин Роман on 25/11/2016.
//  Copyright © 2016 Цопин Роман. All rights reserved.
//

import Foundation

enum SubscriptionServiceError: Error {
    case notConnected
}

class SubscriptionService: SocketListener {
    weak var manager: SocketManager?
    var status: SocketListenerStatus = .wait {
        didSet {
            statusChangeHandler?(status)
        }
    }
    
    var ticksHandler: (([Tick]) -> ())?
    var statusChangeHandler: ((SocketListenerStatus) -> ())?
    
    func socketDidReceivedMessage(message: String) {
        if let ticks = TicksParser.parse(message) {
            ticksHandler?(ticks)
        }
    }
    
    func onStatusChange(_ handler: @escaping (SocketListenerStatus) -> ()) {
        self.statusChangeHandler = handler
    }
    
    func onTicks(_ handler: @escaping ([Tick]) -> ()) {
        self.ticksHandler = handler
    }
    
    func subscribe(to symbols: [Symbol], completion: ((Error?) -> ())? = nil) {
        guard manager?.isConnected ?? false else {
            completion?(SubscriptionServiceError.notConnected)
            return
        }
        manager?.send(request: SubscribeRequest(to: symbols))
        completion?(nil)
    }
    
    func unsubscribe(from symbols: [Symbol], completion: ((Error?) -> ())? = nil) {
        guard manager?.isConnected ?? false else {
            completion?(SubscriptionServiceError.notConnected)
            return
        }
        manager?.send(request: UnsubscribeRequest(from: symbols))
        completion?(nil)
    }
}
