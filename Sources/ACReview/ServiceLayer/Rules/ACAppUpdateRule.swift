//
//  ACAppUpdateRule.swift
//
//
//  Created by Pavel Moslienko on 26.06.2024.
//

import Foundation

open class ACAppUpdateRule: ACRequestReviewRule {
    private let userDefaults = ACUserDefaultsService.shared
    private let currentVersionKey = "ACReview_afterUpdateRuleCurrentVersion"

    public init() {}
    
    open var isShouldDisplayRating: Bool {
        guard let currentVersion = Bundle.main.currentVersion else {
            return false
        }
        
        if let savedVersion: String = userDefaults.get(forKey: currentVersionKey) {
            if currentVersion != savedVersion {
                userDefaults.set(currentVersion, forKey: currentVersionKey)
                return true
            }
            return false
        }
        
        userDefaults.set(currentVersion, forKey: currentVersionKey)
        
        return false
    }
}
