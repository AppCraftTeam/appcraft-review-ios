//
//  ACEventDelayRule.swift
//
//
//  Created by Pavel Moslienko on 27.06.2024.
//

import Foundation

open class ACEventDelayRule: ACRequestReviewRule, ACDelayRule {
    private let userDefaults = ACUserDefaultsService.shared

    open var conditionKey: String
    open var totalTimeKey: String
    open var sessionKey: String
    open var minimumUsageTime: TimeInterval
    
    public init(key: String, minimumUsageTime: TimeInterval) {
        self.conditionKey = key
        self.totalTimeKey = key + "_total_time"
        self.sessionKey = key + "_session"
        self.minimumUsageTime = minimumUsageTime
    }
    
    open var isActiveCondition: Bool {
        let val: Bool? = userDefaults.get(forKey: conditionKey)
        return val ?? false
    }
    
    open func setCondition(_ val: Bool) {
        userDefaults.set(val, forKey: conditionKey)
    }

    open var isShouldDisplayRating: Bool {
        guard isActiveCondition else {
            return false
        }
        let currentTimeSpent: TimeInterval = userDefaults.get(forKey: totalTimeKey) ?? 0
        if currentTimeSpent >= minimumUsageTime {
            resetTime()
            return true
        }
        
        return false
    }
}
