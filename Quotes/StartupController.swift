import UIKit


/* 
    Synchronization point. Suitable for any initialization and running conditional screens (e.g. App Tour or Auth screens).
*/
class StartupController: UIViewController {
    
    private let startupService = StartupService()

    override func viewDidLoad() {
        super.viewDidLoad()
        startupService.run()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Launch main interface when all necessary tasks are done.
        showMainInterface()
    }
}


/*
    Navigation 
*/
extension StartupController {
    func showMainInterface() {
        performSegue(withIdentifier: "mainInterfaceSegue", sender: self)
    }
}
