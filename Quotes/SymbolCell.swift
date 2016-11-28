import UIKit

struct SymbolCellData {
    let symbol: String
    let active: Bool
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
