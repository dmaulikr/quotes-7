//
//  SettingsController.swift
//  Quotes
//
//  Created by Цопин Роман on 25/11/2016.
//  Copyright © 2016 Цопин Роман. All rights reserved.
//

import UIKit


class SettingsController: UITableViewController {
    
    // MARK - State
    var data = Symbol.all
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clearsSelectionOnViewWillAppear = false
    }
    
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
        
        cell.setData(SymbolCellData(for: data[indexPath.row]))
        return cell
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let symbol = data[indexPath.row]
        let active = StorageService.activeSymbols().contains(symbol)
        StorageService.storeSymbolActive(!active, for: symbol)
        
        if let cell = tableView.cellForRow(at: indexPath) {
            if let  cell = cell as? SymbolCell {
                cell.setData(SymbolCellData(for: symbol))
            }
        }
    }

}
