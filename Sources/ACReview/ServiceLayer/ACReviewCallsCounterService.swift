//
//  ACReviewCallsCounterService.swift
//
//
//  Created by Pavel Moslienko on 26.06.2024.
//

import Foundation

public class ACReviewCallsCounterService {
    private let userDefaults = ACUserDefaultsService.shared
    private let attemptsKey = "ACReview_reviewCallsCounterService"

    public func incrementAttempt() {
        userDefaults.incrementNum(forKey: attemptsKey)
    }
    
    public func getCurrentAttempts() -> Int {
        let val: Int = userDefaults.get(forKey: attemptsKey) ?? 0
        return val
    }
    
    public func resetAttempts() {
        userDefaults.remove(forKey: attemptsKey)
    }
}
