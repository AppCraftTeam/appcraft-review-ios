//
//  AppViewController.swift
//  ACReviewDemo
//
//  Created by Дмитрий Поляков on 22.08.2022.
//

import Foundation
import DPUIKit

class AppViewController: DPViewController {
    
    // MARK: - Props
    private var model: AppViewModel? {
        get { self._model as? AppViewModel }
        set { self._model = newValue }
    }
    
    // MARK: - Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}
