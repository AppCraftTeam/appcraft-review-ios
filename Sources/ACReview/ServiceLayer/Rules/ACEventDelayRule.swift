//
//  ACEventDelayRule.swift
//
//
//  Created by Pavel Moslienko on 27.06.2024.
//

import Foundation

/// Show an evaluation request after a specified period of time of using the app after an action has been performed by user
open class ACEventDelayRule: ACRequestReviewRule, ACDelayRule {
    private let userDefaults = ACUserDefaultsService.shared

    open var conditionKey: String
    open var totalTimeKey: String
    open var sessionKey: String
    open var minimumUsageTime: TimeInterval
    
    public init(key: String, minimumUsageTime: ACTimeUnit) {
        self.conditionKey = key
        self.totalTimeKey = key + "_total_time"
        self.sessionKey = key + "_session"
        self.minimumUsageTime = minimumUsageTime.secondsTimeInterval
    }
    
    open var isActiveCondition: Bool {
        let val: Bool? = userDefaults.get(forKey: conditionKey)
        return val ?? false
    }
    
    open func setCondition(_ val: Bool) {
        userDefaults.set(val, forKey: conditionKey)
    }

    open func shouldDisplayRating(_ completion: @escaping (Bool) -> Void) {
        guard isActiveCondition else {
            completion(false)
            return
        }
        /// Check whether the stored usage time corresponds to the required time value
        let currentTimeSpent: TimeInterval = userDefaults.get(forKey: totalTimeKey) ?? 0
        if currentTimeSpent >= minimumUsageTime {
            resetTime()
            completion(true)
            return
        }
        
        completion(false)
    }
}
