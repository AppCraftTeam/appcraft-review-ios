//
//  AppCoordinator.swift
//  ACReviewDemo
//
//  Created by Дмитрий Поляков on 22.08.2022.
//

import Foundation
import DPUIKit

class AppCoordinator: DPWindowCoordinator {
    
    override func start() {
        super.start()
        
        let vc = MenuViewController()
        self.show(vc)
    }
    
}
