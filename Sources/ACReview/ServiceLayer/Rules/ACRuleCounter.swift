//
//  ACRuleCounter.swift
//
//
//  Created by Pavel Moslienko on 24.06.2024.
//

import Foundation

open class ACRuleCounter: ACRequestReviewRule {
    private let userDefaults = ACUserDefaultsService.shared
    private let customFlagKey: String
    private let threshold: Int
    
    public init(customFlagKey: String, threshold: Int = 5) {
        self.customFlagKey = customFlagKey
        self.threshold = threshold
    }
    
    open func incrementFlag() {
        userDefaults.incrementNum(forKey: customFlagKey)
    }
    
    open var isShouldDisplayRating: Bool {
        let currentFlag: Int = userDefaults.get(forKey: customFlagKey) ?? 0
        if currentFlag >= threshold {
            userDefaults.set(0, forKey: customFlagKey)
            return true
        }
        
        return false
    }
}
