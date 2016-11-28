import Foundation
import Unbox


/* 
    Parsers for all kinds of socket responses.
*/
extension SubscribeResponse: Unboxable {
    init(unboxer: Unboxer) throws {
        self.ticksResponse = try unboxer.unbox(key: "subscribed_list")
    }
}

extension UnsubscribeResponse: Unboxable {
    init(unboxer: Unboxer) throws {
        self.ticksResponse = try unboxer.unbox(key: "subscribed_list")
    }
}

extension TicksResponse: Unboxable {
    init(unboxer: Unboxer) throws {
        self.ticks = try unboxer.unbox(key: "ticks")
    }
}

extension Tick: Unboxable {
    init(unboxer: Unboxer) throws {
        self.symbol = try unboxer.unbox(key: "s")
        self.ask = try unboxer.unbox(key: "a")
        self.bid = try unboxer.unbox(key: "b")
        self.spread = try unboxer.unbox(key: "spr")
    }
}


