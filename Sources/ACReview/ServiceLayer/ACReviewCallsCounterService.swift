//
//  ACReviewCallsCounterService.swift
//
//
//  Created by Pavel Moslienko on 26.06.2024.
//

import Foundation

open class ACReviewCallsCounterService {
    private let userDefaults = ACUserDefaultsService.shared
    private let attemptsKey = "ACReview_reviewCallsCounterService"

    open func incrementAttempt() {
        userDefaults.incrementNum(forKey: attemptsKey)
    }
    
    open func getCurrentAttempts() -> Int {
        let val: Int = userDefaults.get(forKey: attemptsKey) ?? 0
        return val
    }
    
    open func resetAttempts() {
        userDefaults.remove(forKey: attemptsKey)
    }
}
