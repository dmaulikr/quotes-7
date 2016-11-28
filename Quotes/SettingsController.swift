import UIKit


class SettingsController: UITableViewController {
    
    // MARK - State    
    let storageService = StorageService()
    var data = Symbol.all
    
    
    // MARK: - View life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }


    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SymbolCell.reuseId, for: indexPath) as! SymbolCell
        
        let symbol = data[indexPath.row]
        let active = storageService.isSymbolActive(symbol)
        cell.setData(SymbolCellData(symbol: symbol.description, active: active))
        
        return cell
    }
    
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let symbol = data[indexPath.row]
        let active = storageService.isSymbolActive(symbol)
        storageService.storeSymbolActive(!active, for: symbol)
        
        if let cell = tableView.cellForRow(at: indexPath) {
            if let  cell = cell as? SymbolCell {
                cell.setData(SymbolCellData(symbol: symbol.description, active: !active))
            }
        }
    }

}
