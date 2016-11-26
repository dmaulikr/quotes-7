//
//  SymbolCell.swift
//  Quotes
//
//  Created by Цопин Роман on 25/11/2016.
//  Copyright © 2016 Цопин Роман. All rights reserved.
//

import UIKit

struct SymbolCellData {
    let symbol: String
    let active: Bool
}

extension SymbolCellData {
    init(for symbol: Symbol) {
        self.symbol = symbol.description
        self.active = StorageService.activeSymbols().contains(symbol)
    }
}

class SymbolCell: UITableViewCell {
    static let reuseId = "symbolCellReuseId"
    @IBOutlet weak var symbolLabel: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(_ data: SymbolCellData) {
        symbolLabel.text = data.symbol
        accessoryType = data.active ? .checkmark : .none
    }
}
