import Foundation


/* 
    StartupService runs tasks on launch.
*/
class StartupService {
    
    private let storageService = StorageService()
    
    func run() {
        if storageService.isFirstLaunch() {
            initActiveSymbols()
        }
        
        connectToSocket()
    }
    
    private func initActiveSymbols() {
        for (order, symbol) in Symbol.all.enumerated() {
            storageService.storeSymbolActive(true, for: symbol)
            storageService.storeOrder(order, for: symbol)
        }
    }
    
    private func connectToSocket() {
        Socket.instance.connect()
    }
}
