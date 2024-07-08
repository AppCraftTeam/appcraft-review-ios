//
//  AppCoordinator.swift
//  ACReviewDemo
//
//  Created by Дмитрий Поляков on 22.08.2022.
//

import Foundation
import DPUIKit
import UIKit

class AppCoordinator: DPWindowCoordinator {
    
    override func start() {
        super.start()
        
        let vc = MenuViewController()
        self.show(UINavigationController(rootViewController: vc))
    }
    
}
