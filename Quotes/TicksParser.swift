import Foundation
import Unbox


/* 
    TicksParser parses socket reponses using response parsers and tries to find any ticks data.
*/
class TicksParser {
    
    func parse(_ message: String) -> [Tick]? {
        let data = message.data(using: .utf8)
        if let subscribeResponse: SubscribeResponse = try? unbox(data: data!) {
            return subscribeResponse.ticksResponse.ticks
        } else if let unsubscribeResponse: UnsubscribeResponse = try? unbox(data: data!) {
            return unsubscribeResponse.ticksResponse.ticks
        } else if let ticksResponse: TicksResponse = try? unbox(data: data!) {
            return ticksResponse.ticks
        } else {
            return nil
        }
    }
    
}
