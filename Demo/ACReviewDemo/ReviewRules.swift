//
//  ReviewRules.swift
//  ACReviewDemo
//
//  Created by Pavel Moslienko on 08.07.2024.
//

import Foundation
import ACReview

class ReviewRules {
    
    static let appUpdateWithDelayRule = ACAppUpdateWithDelayRule(minimumUsageTime: .minutes(5))
    static let eventDelayRule = ACEventDelayRule(key: AppKeys.eventDelayRuleKey, minimumUsageTime: .minutes(5))
    static let timeSpentRule = ACEventDelayRule(key: AppKeys.ruleCounterKey, minimumUsageTime: .minutes(5))
    static let seriallyRule = ACSeriallyRule(actionFrequency: .daily(everyXDays: 2))
    static let appUpdateRule = ACAppUpdateRule()
    static let counterRule = ACRuleCounter(customFlagKey: AppKeys.ruleCounterKey, threshold: 5)
}
