//
//  InitialViewController.swift
//  ACReviewDemo
//
//  Created by Дмитрий Поляков on 22.08.2022.
//  Copyright © 2022 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation
import UIKit
import DPUIKit

class InitialViewController: AppViewController {
    
    // MARK: - Init
    override init() {
        super.init()
        
        self.model = .init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Props
    private var model: InitialViewModel? {
        get { self._model as? InitialViewModel }
        set { self._model = newValue }
    }
    
    // MARK: - Methods
    
}
