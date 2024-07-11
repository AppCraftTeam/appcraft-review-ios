//
//  ACAppUpdateRule.swift
//
//
//  Created by Pavel Moslienko on 26.06.2024.
//

import Foundation

/// Show an evaluation request after a certain amount of time using the app after the app has been upgraded to a new version
open class ACAppUpdateRule: ACRequestReviewRule {
    private let userDefaults = ACUserDefaultsService.shared
    private let currentVersionKey = "ACReview_afterUpdateRuleCurrentVersion"
    
    /// Get current app version
    var currentVersion: String? {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    public init() {}
    
    open func shouldDisplayRating(_ completion: @escaping (Bool) -> Void) {
        guard let currentVersion = currentVersion else {
            completion(false)
            return
        }
        
        /// Check app version
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
