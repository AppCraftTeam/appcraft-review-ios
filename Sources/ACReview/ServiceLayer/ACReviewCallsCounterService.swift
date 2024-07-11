//
//  ACReviewCallsCounterService.swift
//
//
//  Created by Pavel Moslienko on 26.06.2024.
//

import Foundation

public protocol ACReviewCallsCounter {
    func incrementAttempt()
    func getCurrentAttempts() -> Int
    func resetAttempts()
}

/// A set of methods for counting the number of calls to the request review call
open class ACReviewCallsCounterService: ACReviewCallsCounter {
    private let userDefaults = ACUserDefaultsService.shared
    private let attemptsKey = "ACReview_reviewCallsCounterService"
    
    public init() {}
    
    open func incrementAttempt() {
        userDefaults.incrementNum(forKey: attemptsKey)
    }
    
    open func getCurrentAttempts() -> Int {
        userDefaults.get(forKey: attemptsKey) ?? 0
    }
    
    open func resetAttempts() {
        userDefaults.remove(forKey: attemptsKey)
    }
}
