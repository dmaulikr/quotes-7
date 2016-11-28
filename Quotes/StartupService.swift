import Foundation


/* 
    StartupService is suitable for runing tasks on application launch.
*/
class StartupService {
    
    let storageService = StorageService()
    
    func run() {
        if storageService.isFirstLaunch() {
            initActiveSymbols()
        }
        
        connectToSocket()
    }
    
    
    private func initActiveSymbols() {
        for (idx, symbol) in Symbol.all.enumerated() {
            storageService.storeSymbolActive(true, for: symbol)
            storageService.storeOrder(idx, for: symbol)
        }
    }
    
    private func connectToSocket() {
        Socket.instance.connect()
    }
}
