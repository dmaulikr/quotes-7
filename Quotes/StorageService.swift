import Foundation


/* 
    StorageService implements simple `redis-like` key-value storage, based on UserDefaults.
*/
class StorageService {
    
    func activeSymbols() -> [Symbol] {
        return Symbol.all.filter { UserDefaults.standard.bool(forKey: activeSymbolKey($0)) }.sorted(by: {
            order(for: $0) < order(for: $1)
        })
    }
    
    func lastTicks(for symbols: [Symbol]) -> [Tick] {
        return symbols.map { lastTick(for: $0) }
    }
    
    func order(for symbol: Symbol) -> Int {
        return UserDefaults.standard.integer(forKey: symbolOrderKey(symbol))
    }
    
    func order(for symbols: [Symbol]) -> [Int] {
        return symbols.map { order(for: $0) }
    }
    
    func storeOrder(_ order: Int, for symbol: Symbol) {
        UserDefaults.standard.set(order, forKey: symbolOrderKey(symbol))
    }
    
    func storeOrder(_ order: [Int], for symbols: [Symbol]) {
        for (index, symbol) in symbols.enumerated() {
            storeOrder(order[index], for: symbol)
        }
        sync()
    }
    
    func isSymbolActive(_ symbol: Symbol) -> Bool {
        return UserDefaults.standard.bool(forKey: activeSymbolKey(symbol))
    }
    
    func storeSymbolActive(_ active: Bool, for symbol: Symbol) {
        UserDefaults.standard.set(active, forKey: activeSymbolKey(symbol))
        sync()
    }
    
    func lastTick(for symbol: Symbol) -> Tick {
        let ask = lastAsk(for: symbol)
        let bid = lastBid(for: symbol)
        let spread = lastSpread(for: symbol)
        return Tick(symbol: symbol, ask: ask, bid: bid, spread: spread)
    }
    
    func storeLastTick(_ tick: Tick) {
        storeLastAsk(tick.ask, for: tick.symbol)
        storeLastBid(tick.bid, for: tick.symbol)
        storeLastSpread(tick.spread, for: tick.symbol)
        sync()
    }
    
    func storeLastAsk(_ value: Double, for symbol: Symbol) {
        UserDefaults.standard.set(value, forKey: lastAskKey(symbol))
    }
    
    func storeLastBid(_ value: Double, for symbol: Symbol) {
        UserDefaults.standard.set(value, forKey: lastBidKey(symbol))
    }
    
    func storeLastSpread(_ value: Double, for symbol: Symbol) {
        UserDefaults.standard.set(value, forKey: lastSpreadKey(symbol))
    }
    
    func lastAsk(for symbol: Symbol) -> Double {
        return UserDefaults.standard.double(forKey: lastAskKey(symbol))
    }
    
    func lastBid(for symbol: Symbol) -> Double {
        return UserDefaults.standard.double(forKey: lastBidKey(symbol))
    }
    
    func lastSpread(for symbol: Symbol) -> Double {
        return UserDefaults.standard.double(forKey: lastSpreadKey(symbol))
    }
    
    func isFirstLaunch() -> Bool {
        defer {
            UserDefaults.standard.set(true, forKey: firstRunKey)
            UserDefaults.standard.synchronize()
        }
        return !UserDefaults.standard.bool(forKey: firstRunKey)
    }
    
    func sync() {
        UserDefaults.standard.synchronize()
    }
    
    private func lastAskKey(_ symbol: Symbol) -> String {
        return "\(symbol.rawValue)-lastAsk"
    }
    
    private func lastBidKey(_ symbol: Symbol) -> String {
        return "\(symbol.rawValue)-lastBid"
    }
    
    private func lastSpreadKey(_ symbol: Symbol) -> String {
        return "\(symbol.rawValue)-lastSpread"
    }
    
    private func activeSymbolKey(_ symbol: Symbol) -> String {
        return "\(symbol.rawValue)-active"
    }
    
    private func symbolOrderKey(_ symbol: Symbol) -> String {
        return "\(symbol.rawValue)-order"
    }
    
    private let firstRunKey = "firstRun"
}
