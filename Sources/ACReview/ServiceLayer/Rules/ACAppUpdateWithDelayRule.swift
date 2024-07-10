//
//  ACAppUpdateWithDelayRule.swift
//
//
//  Created by Pavel Moslienko on 26.06.2024.
//

import Foundation

/// Show an evaluation request after a specified time of using a new version of the application
open class ACAppUpdateWithDelayRule: ACRequestReviewRule, ACDelayRule {
    private let userDefaults = ACUserDefaultsService.shared
    private var currentVersionKey = "ACReview_afterUpdateDelayRuleCurrentVersion"
    
    open var sessionKey: String {
        totalTimeKey + "_session"
    }
    open var totalTimeKey: String = "ACReview_afterUpdateDelayRule_totalTime"
    open var minimumUsageTime: TimeInterval
    
    public init(minimumUsageTime: ACTimeUnit) {
        self.minimumUsageTime = minimumUsageTime.secondsTimeInterval
    }
    
    open var isActiveCondition: Bool {
        /// Check app version
        guard let currentVersion = Bundle.main.currentVersion else {
            return false
        }
        
        if let savedVersion: String = userDefaults.get(forKey: currentVersionKey) {
            return currentVersion != savedVersion
        }
        
        return false
    }
    
    open func shouldDisplayRating(_ completion: @escaping (Bool) -> Void) {
        let currentTimeSpent: TimeInterval = userDefaults.get(forKey: totalTimeKey) ?? 0
        if currentTimeSpent >= minimumUsageTime {
            resetTime()
            if let currentVersion = Bundle.main.currentVersion {
                userDefaults.set(currentVersion, forKey: currentVersionKey)
            }
            
            completion(true)
            return
        }
        
        completion(false)
    }
    
    open func setCondition(_ val: Bool) {}
}
