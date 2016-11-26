//
//  TickCell.swift
//  Quotes
//
//  Created by Цопин Роман on 25/11/2016.
//  Copyright © 2016 Цопин Роман. All rights reserved.
//

import UIKit

struct TickCellData {
    let symbol: String
    let bidAsk: String
    let spread: String
}

extension TickCellData {
    init(tick: Tick) {
        self.init(symbol: tick.symbol.description, bidAsk: "\(String(tick.bid)) / \(String(tick.ask))", spread: String(tick.spread))
    }
}

class TickCell: UITableViewCell {
    static let reuseId = "TickCellReuseId"

    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var bidAskLabel: UILabel!
    @IBOutlet weak var spreadLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(_ data: TickCellData) {
        self.symbolLabel.text = data.symbol
        self.bidAskLabel.text = data.bidAsk
        self.spreadLabel.text = data.spread
    }
}
