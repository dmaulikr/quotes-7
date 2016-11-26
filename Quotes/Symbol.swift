//
//  Symbols.swift
//  Quotes
//
//  Created by Цопин Роман on 24/11/2016.
//  Copyright © 2016 Цопин Роман. All rights reserved.
//

import Foundation
import Unbox

public enum Symbol: String, CustomStringConvertible, UnboxableEnum {
    case EURUSD, EURGBP, USDJPY, GBPUSD, USDCHF, USDCAD, AUDUSD, EURJPY, EURCHF
    static let all: [Symbol] = [.EURUSD, .EURGBP, .USDJPY, .GBPUSD, .USDCHF, .USDCAD, .AUDUSD, .EURJPY, .EURCHF]
    
    public var description: String {
        let first = rawValue.substring(to: rawValue.index(rawValue.startIndex, offsetBy: 3))
        let second = rawValue.substring(from: rawValue.index(rawValue.startIndex, offsetBy: 3))
        return "\(first)/\(second)"
    }
}
