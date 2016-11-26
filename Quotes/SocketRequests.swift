//
//  SocketRequests.swift
//  Quotes
//
//  Created by Цопин Роман on 25/11/2016.
//  Copyright © 2016 Цопин Роман. All rights reserved.
//

import Foundation

struct SubscribeRequest: CustomStringConvertible {
    let symbols: [Symbol]
    init(to symbols: [Symbol]) {
        self.symbols = symbols
    }
    var description: String {
        return "SUBSCRIBE: \(symbols.map { $0.rawValue }.joined(separator: ","))"
    }
}

struct UnsubscribeRequest: CustomStringConvertible {
    let symbols: [Symbol]
    init(from symbols: [Symbol]) {
        self.symbols = symbols
    }
    var description: String {
        return "UNSUBSCRIBE: \(symbols.map { $0.rawValue }.joined(separator: ","))"
    }
}
