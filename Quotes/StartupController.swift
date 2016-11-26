//
//  StartupController.swift
//  Quotes
//
//  Created by Цопин Роман on 25/11/2016.
//  Copyright © 2016 Цопин Роман. All rights reserved.
//

import UIKit

/* Synchronization point. Good for resource initializing and running conditional screens (e.g. App Tour or Auth screens) */

class StartupController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        StartupService.run()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        performSegue(withIdentifier: "mainInterfaceSegue", sender: self)
    }
}
