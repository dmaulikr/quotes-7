//
//  Storage.swift
//  Quotes
//
//  Created by Цопин Роман on 25/11/2016.
//  Copyright © 2016 Цопин Роман. All rights reserved.
//

import Foundation

/* Simple redis-like key-value storage based on UserDefaults */

class StorageService {
    static func activeSymbols() -> [Symbol] {
        return Symbol.all.filter { UserDefaults.standard.bool(forKey: activeSymbolKey($0)) }.sorted(by: {
            StorageService.order(for: $0) < StorageService.order(for: $1)
        })
    }
    
    static func lastTicks(for symbols: [Symbol]) -> [Tick] {
        return symbols.map { StorageService.lastTick(for: $0) }
    }
    
    static func order(for symbol: Symbol) -> Int {
        return UserDefaults.standard.integer(forKey: symbolOrderKey(symbol))
    }
    
    static func order(for symbols: [Symbol]) -> [Int] {
        return symbols.map { StorageService.order(for: $0) }
    }
    
    static func storeOrder(_ order: Int, for symbol: Symbol) {
        UserDefaults.standard.set(order, forKey: symbolOrderKey(symbol))
    }
    
    static func storeOrder(_ order: [Int], for symbols: [Symbol]) {
        for (index, symbol) in symbols.enumerated() {
            StorageService.storeOrder(order[index], for: symbol)
        }
    }
    
    static func storeSymbolActive(_ active: Bool, for symbol: Symbol) {
        UserDefaults.standard.set(active, forKey: activeSymbolKey(symbol))
    }
    
    static func lastTick(for symbol: Symbol) -> Tick {
        let ask = lastAsk(for: symbol)
        let bid = lastBid(for: symbol)
        let spread = lastSpread(for: symbol)
        return Tick(symbol: symbol, ask: ask, bid: bid, spread: spread)
    }
    
    static func storeLastTick(_ tick: Tick) {
        storeLastAsk(tick.ask, for: tick.symbol)
        storeLastBid(tick.bid, for: tick.symbol)
        storeLastSpread(tick.spread, for: tick.symbol)
    }
    
    static func storeLastAsk(_ value: Double, for symbol: Symbol) {
        UserDefaults.standard.set(value, forKey: lastAskKey(symbol))
    }
    
    static func storeLastBid(_ value: Double, for symbol: Symbol) {
        UserDefaults.standard.set(value, forKey: lastBidKey(symbol))
    }
    
    static func storeLastSpread(_ value: Double, for symbol: Symbol) {
        UserDefaults.standard.set(value, forKey: lastSpreadKey(symbol))
    }
    
    static func lastAsk(for symbol: Symbol) -> Double {
        return UserDefaults.standard.double(forKey: lastAskKey(symbol))
    }
    
    static func lastBid(for symbol: Symbol) -> Double {
        return UserDefaults.standard.double(forKey: lastBidKey(symbol))
    }
    
    static func lastSpread(for symbol: Symbol) -> Double {
        return UserDefaults.standard.double(forKey: lastSpreadKey(symbol))
    }
    
    static func firstRun() -> Bool {
        defer { UserDefaults.standard.set(true, forKey: firstRunKey) }
        return !UserDefaults.standard.bool(forKey: firstRunKey)
    }
    
    private static func lastAskKey(_ symbol: Symbol) -> String {
        return "\(symbol.rawValue)-lastAsk"
    }
    
    private static func lastBidKey(_ symbol: Symbol) -> String {
        return "\(symbol.rawValue)-lastBid"
    }
    
    private static func lastSpreadKey(_ symbol: Symbol) -> String {
        return "\(symbol.rawValue)-lastSpread"
    }
    
    private static func activeSymbolKey(_ symbol: Symbol) -> String {
        return "\(symbol.rawValue)-active"
    }
    private static func symbolOrderKey(_ symbol: Symbol) -> String {
        return "\(symbol.rawValue)-order"
    }
    
    private static let firstRunKey = "firstRun"
}
