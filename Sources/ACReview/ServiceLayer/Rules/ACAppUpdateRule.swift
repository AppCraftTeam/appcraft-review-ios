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
    
    open func shouldDisplayRating(_ completion: @escaping (Bool) -> Void) {
        guard let currentVersion = Bundle.main.currentVersion else {
            completion(false)
            return
        }
        
        if let savedVersion: String = userDefaults.get(forKey: currentVersionKey) {
            if currentVersion != savedVersion {
                userDefaults.set(currentVersion, forKey: currentVersionKey)
                completion(true)
                return
            }
            completion(false)
            return
        }
        
        userDefaults.set(currentVersion, forKey: currentVersionKey)
        completion(false)
    }
}
