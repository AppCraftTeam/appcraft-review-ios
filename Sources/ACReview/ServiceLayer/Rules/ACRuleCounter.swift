//
//  ACRuleCounter.swift
//
//
//  Created by Pavel Moslienko on 24.06.2024.
//

import Foundation

/// Show an evaluation request after the user performs a specific action a number of times
open class ACRuleCounter: ACRequestReviewRule {
    private let userDefaults = ACUserDefaultsService.shared
    private let customFlagKey: String
    private let threshold: Int
    
    public init(customFlagKey: String, threshold: Int) {
        self.customFlagKey = customFlagKey
        self.threshold = threshold
    }
    
    open func incrementFlag() {
        userDefaults.incrementNum(forKey: customFlagKey)
    }
    
    open func shouldDisplayRating(_ completion: @escaping (Bool) -> Void) {
        let currentFlag: Int = userDefaults.get(forKey: customFlagKey) ?? 0
        if currentFlag >= threshold {
            userDefaults.set(0, forKey: customFlagKey)
            completion(true)
            return
        }
        
        completion(false)
    }
}
