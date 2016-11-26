//
//  SocketListener.swift
//  Quotes
//
//  Created by Цопин Роман on 25/11/2016.
//  Copyright © 2016 Цопин Роман. All rights reserved.
//

import Foundation

enum SocketListenerStatus {
    case wait, active
}

/* Sub for SocketManager */
protocol SocketListener: class {
    weak var manager: SocketManager? { get set }
    var status: SocketListenerStatus { get set }
    var id: String { get }
    
    func socketDidReceivedMessage(message: String)
    
    func managerDidConnected()
    func managerDidDisconnected(error: Error?)
    
    func startListening(manager: SocketManager)
    func stopListening()
    func restart()
}

/* Default implementation */
extension SocketListener {
    var id: String { return UUID().uuidString }
    
    func startListening(manager: SocketManager) {
        self.manager = manager
        if manager.isConnected { status = .active }
        manager.addListener(self)
    }
    func stopListening() {
        manager?.removeListener(self)
        status = .wait
        manager = nil
    }
    func restart() {
        if let manager = self.manager {
            stopListening()
            startListening(manager: manager)
        }
    }
    
    func managerDidConnected() {
        status = .active
    }
    func managerDidDisconnected(error: Error?) {
        status = .wait
    }
}
