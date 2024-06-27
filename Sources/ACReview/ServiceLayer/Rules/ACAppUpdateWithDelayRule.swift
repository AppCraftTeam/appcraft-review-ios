//
//  ACAppUpdateWithDelayRule.swift
//
//
//  Created by Pavel Moslienko on 26.06.2024.
//

import Foundation

// Показать запрос оценки через определенное время использования новой версии приложения
public class ACAppUpdateWithDelayRule: ACRequestStorage, ACRequestReviewRule, ACDelayRule {
    var currentVersionKey = "ACReview_afterUpdateDelayRuleCurrentVersion"
    public var totalTimeKey: String = "ACReview_afterUpdateDelayRule_totalTime"
    public var sessionKey: String {
        totalTimeKey + "_session"
    }
    public var minimumUsageTime: TimeInterval
    
    public init(minimumUsageTimeInMinutes: TimeInterval) {
        self.minimumUsageTime = minimumUsageTimeInMinutes * 60
    }
    
    public var isActiveCondition: Bool {
        guard let currentVersion = Bundle.main.currentVersion else {
            return false
        }
        
        if let savedVersion: String = userDefaults.get(forKey: currentVersionKey) {
            return currentVersion != savedVersion
        }
        
        return false
    }
    
    public var isShouldDisplayRating: Bool {
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
    
    public func setCondition(_ val: Bool) {}
}
