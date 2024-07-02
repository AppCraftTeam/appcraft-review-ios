//
//  ACAppUpdateWithDelayRule.swift
//
//
//  Created by Pavel Moslienko on 26.06.2024.
//

import Foundation

// Показать запрос оценки через определенное время использования новой версии приложения
open class ACAppUpdateWithDelayRule: ACRequestReviewRule, ACDelayRule {
    private let userDefaults = ACUserDefaultsService.shared
    private var currentVersionKey = "ACReview_afterUpdateDelayRuleCurrentVersion"
    
    open var sessionKey: String {
        totalTimeKey + "_session"
    }
    open var totalTimeKey: String = "ACReview_afterUpdateDelayRule_totalTime"
    open var minimumUsageTime: TimeInterval
    
    public init(minimumUsageTimeInMinutes: TimeInterval) {
        self.minimumUsageTime = minimumUsageTimeInMinutes * 60
    }
    
    open var isActiveCondition: Bool {
        guard let currentVersion = Bundle.main.currentVersion else {
            return false
        }
        
        if let savedVersion: String = userDefaults.get(forKey: currentVersionKey) {
            return currentVersion != savedVersion
        }
        
        return false
    }
    
    open var isShouldDisplayRating: Bool {
        let currentTimeSpent: TimeInterval = userDefaults.get(forKey: totalTimeKey) ?? 0
        if currentTimeSpent >= minimumUsageTime {
            resetTime()
            if let currentVersion = Bundle.main.currentVersion {
                userDefaults.set(currentVersion, forKey: currentVersionKey)
            }
            
            return true
        }
        
        return false
    }
    
    open func setCondition(_ val: Bool) {}
}
