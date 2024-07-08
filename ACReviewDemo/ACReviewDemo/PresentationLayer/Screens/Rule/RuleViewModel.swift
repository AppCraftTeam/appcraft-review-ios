//
//  RuleViewModel.swift
//  ACReviewDemo
//
//  Created by Pavel Moslienko on 04.07.2024.
//

import ACReview
import Foundation

final class RuleViewModel {
    
    let ruleType: ReviewMenuRule
    
    let appUpdateWithDelayRule = ACAppUpdateWithDelayRule(minimumUsageTime: .minutes(5))
    let eventDelayRule = ACEventDelayRule(key: AppKeys.eventDelayRuleKey, minimumUsageTime: .minutes(5))
    let timeSpentRule = ACEventDelayRule(key: AppKeys.ruleCounterKey, minimumUsageTime: .minutes(5))

    init(ruleType: ReviewMenuRule) {
        self.ruleType = ruleType
    }
}
