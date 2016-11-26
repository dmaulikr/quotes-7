//
//  StartupService.swift
//  Quotes
//
//  Created by Цопин Роман on 25/11/2016.
//  Copyright © 2016 Цопин Роман. All rights reserved.
//

import Foundation

class StartupService {

    static func run() {
        if StorageService.firstRun() {
            storeActiveSymbols()
        }
        connectToSocket()
    }
    
    static func storeActiveSymbols() {
        for (idx, symbol) in Symbol.all.enumerated() {
            StorageService.storeSymbolActive(true, for: symbol)
            StorageService.storeOrder(idx, for: symbol)
        }
    }
    
    static func connectToSocket() {
        SocketManager.instance.connect()
    }
}
