import UIKit

class TicksController: UITableViewController {
    
    // MARK - State
    
    /* Ticks displayed in tableView */
    var data = [Tick]()
    
    private let ticksListeningService = TicksListeningService()
    private let storageService = StorageService()
    
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = self.editButtonItem
        
        setupTicksListeningService()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /* Init ticks from storage */
        data = storageService.lastTicks(for: storageService.activeSymbols())
        tableView.reloadData()
        
        ticksListeningService.startListening(socket: Socket.instance)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        ticksListeningService.stopListening()
    }
    
    
    // MARK: Ticks Listening
    private func setupTicksListeningService() {
        
        ticksListeningService.onStatusChange { [weak self] status in
            if status == .active {
                if let `self` = self {

                    let activeSymbols = self.storageService.activeSymbols()
                    let inactiveSymbols = Symbol.all.filter { !activeSymbols.contains($0) }
                    
                    self.ticksListeningService.unsubscribe(from: inactiveSymbols)
                    self.ticksListeningService.subscribe(to: activeSymbols)
                }
            }
        }
        
        ticksListeningService.onTicks { [weak self] ticks in
            
            /* Update ticks data if not in editing state */
            
            if let `self` = self, !self.isEditing {
                
                let ticks = ticks.filter { self.data.map { $0.symbol }.contains($0.symbol) }
                let positions = ticks.flatMap { tick in self.data.index { $0.symbol == tick.symbol } }
                
                for (index, tick) in ticks.enumerated() {
                    self.data[positions[index]] = tick
                    self.storageService.storeLastTick(tick)
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
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showGraph()
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let symbol = data[indexPath.row].symbol
            data = data.filter { $0.symbol != symbol }
            
            storageService.storeSymbolActive(false, for: symbol)
            ticksListeningService.unsubscribe(from: [symbol])
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    

    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        
        guard fromIndexPath != to else { return }

        data.insert(data.remove(at: fromIndexPath.row), at: to.row)
        
        let symbols = data.map { $0.symbol }
        storageService.storeOrder(storageService.order(for: symbols).sorted(), for: symbols)

    }
}

/* 
    Navigation 
*/
extension TicksController {
    
    func showGraph() {
        performSegue(withIdentifier: "showGraphSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showGraphSegue" {
            if let graphController = segue.destination as? GraphController, let
                indexPath = tableView.indexPathForSelectedRow {
                let symbolForGraph = data[indexPath.row].symbol
                graphController.symbolToListen = symbolForGraph
            }
        }
    }
}
