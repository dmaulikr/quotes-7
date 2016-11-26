//
//  SocketResponse.swift
//  Quotes
//
//  Created by Цопин Роман on 25/11/2016.
//  Copyright © 2016 Цопин Роман. All rights reserved.
//

import Foundation
import Unbox

struct TicksResponse {
    let ticks: [Tick]
}

struct SubscribeResponse {
    let ticksResponse: TicksResponse
}

struct UnsubscribeResponse {
    let ticksResponse: TicksResponse
}
