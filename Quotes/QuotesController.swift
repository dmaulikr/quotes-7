//
//  QuotesController.swift
//  Quotes
//
//  Created by Цопин Роман on 25/11/2016.
//  Copyright © 2016 Цопин Роман. All rights reserved.
//

import UIKit

// TODO: rename
// QuotesController / SubscriptionService / quoteService / Ticks

// TODO: services (static vs instance based)
// TODO: incapsulate storage service

// PROPOSAL: ticksController, TicksSubscribtionService
// PROPOSAL: abstract controllers from storage (lastTicksForSymbols, activeSymbols)

class QuotesController: UITableViewController {
    
    // MARK - State
    let quoteService = SubscriptionService()
    
    var data = [Tick]()
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        clearsSelectionOnViewWillAppear = false
        navigationItem.rightBarButtonItem = self.editButtonItem
        
        setupSubscriptionService()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        data = StorageService.lastTicks(for: StorageService.activeSymbols())
        tableView.reloadData()
        
        quoteService.startListening(manager: SocketManager.instance)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        quoteService.stopListening()
    }
    
    
    func setupSubscriptionService() {
        
        quoteService.onStatusChange { [weak self] status in
            if status == .active {
                let activeSymbols = StorageService.activeSymbols()
                let inactiveSymbols = Symbol.all.filter { !activeSymbols.contains($0) }
                
                self?.quoteService.unsubscribe(from: inactiveSymbols)
                self?.quoteService.subscribe(to: activeSymbols)
            }
        }
        
        quoteService.onTicks { [weak self] ticks in
            
            /* Update ticks data if not in editing state */
            if let `self` = self, !self.isEditing {
                
                let ticks = ticks.filter { self.data.map { $0.symbol }.contains($0.symbol) }
                let positions = ticks.flatMap { tick in self.data.index { $0.symbol == tick.symbol } }
                
                for (index, tick) in ticks.enumerated() {
                    self.data[positions[index]] = tick
                    StorageService.storeLastTick(tick)
                }
                
                let indexPaths = positions.map { IndexPath(row: $0, section: 0) }
                for indexPath in indexPaths {
                    if let cell = self.tableView.cellForRow(at: indexPath) {
                        if let cell = cell as? TickCell {
                            cell.setData(TickCellData(tick: self.data[indexPath.row]))
                        }
                    }
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TickCell.reuseId, for: indexPath) as! TickCell

        cell.setData(TickCellData(tick: data[indexPath.row]))

        return cell
    }
    
    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let symbol = data[indexPath.row].symbol
            data = data.filter { $0.symbol != symbol }
            
            StorageService.storeSymbolActive(false, for: symbol)
            
            quoteService.unsubscribe(from: [symbol])
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    

    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        
        guard fromIndexPath != to else { return }

        data.insert(data.remove(at: fromIndexPath.row), at: to.row)
        
        let symbols = data.map { $0.symbol }
        StorageService.storeOrder(StorageService.order(for: symbols).sorted(), for: symbols)

    }


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
