import Foundation


/* 
    Structs for assembling requests to socket.
*/
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
