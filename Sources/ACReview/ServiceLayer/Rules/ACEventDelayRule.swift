//
//  ACEventDelayRule.swift
//
//
//  Created by Pavel Moslienko on 27.06.2024.
//

import Foundation

public class ACEventDelayRule: ACRequestStorage, ACRequestReviewRule, ACDelayRule {
    
    public var conditionKey: String
    public var totalTimeKey: String
    public var sessionKey: String
    public var minimumUsageTime: TimeInterval
    
    public init(key: String, minimumUsageTime: TimeInterval) {
        self.conditionKey = key
        self.totalTimeKey = key + "_total_time"
        self.sessionKey = key + "_session"
        self.minimumUsageTime = minimumUsageTime
    }
    
    public var isActiveCondition: Bool {
        let val: Bool? = userDefaults.get(forKey: conditionKey)
        return val ?? false
    }
    
    public func setCondition(_ val: Bool) {
        userDefaults.set(val, forKey: conditionKey)
    }

    public var isShouldDisplayRating: Bool {
        guard isActiveCondition else {
            return false
        }
        let currentTimeSpent: TimeInterval = userDefaults.get(forKey: totalTimeKey) ?? 0
        if currentTimeSpent >= minimumUsageTime {
            userDefaults.set(0, forKey: totalTimeKey)
            userDefaults.remove(forKey: sessionKey)
            
            return true
        }
        
        return false
    }
}
