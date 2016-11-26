//
//  TicksParser.swift
//  Quotes
//
//  Created by Цопин Роман on 25/11/2016.
//  Copyright © 2016 Цопин Роман. All rights reserved.
//

import Foundation
import Unbox

class TicksParser {
    static func parse(_ message: String) -> [Tick]? {
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
