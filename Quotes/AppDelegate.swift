import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let storageService = StorageService()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window?.backgroundColor = .white
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        storageService.sync()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        storageService.sync()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        storageService.sync()
    }
}

