//
//  ACSeriallyRule.swift
//
//
//  Created by Pavel Moslienko on 26.06.2024.
//

import Foundation

/// Show the evaluation request periodically, after a specified interval of time
open class ACSeriallyRule: ACRequestReviewRule {
    private let userDefaults = ACUserDefaultsService.shared
    private let actionFrequency: ACActionFrequency

    public init(actionFrequency: ACActionFrequency) {
        self.actionFrequency = actionFrequency
    }
    
    open func shouldDisplayRating(_ completion: @escaping (Bool) -> Void) {
        let lastPromptDateKey = actionFrequency.key
        
        guard let lastPromptDate: Date = userDefaults.get(forKey: lastPromptDateKey) else {
            // App first launch date
            userDefaults.set(Date(), forKey: lastPromptDateKey)
            completion(false)
            return
        }
        
        let isShouldCallRating = isShouldCallRating(
            with: actionFrequency,
            lastPromptDate: lastPromptDate,
            lastPromptDateKey: lastPromptDateKey
        )
        
        completion(isShouldCallRating)
    }
}

private extension ACSeriallyRule {
    
    /// Check if the current date and the saved original date match for the review alert display frequency
    func isShouldCallRating(with actionFrequency: ACActionFrequency, lastPromptDate: Date, lastPromptDateKey: String) -> Bool {
        let calendar = Calendar.current
        let currentDate = Date()
        
        switch actionFrequency {
        case .onceYear:
            if let nextPromptDate = calendar.date(byAdding: .year, value: 1, to: lastPromptDate),
               currentDate >= nextPromptDate {
                userDefaults.set(currentDate, forKey: lastPromptDateKey)
                return true
            }
        case let .onceEveryMonths(month):
            if let nextPromptDate = calendar.date(byAdding: .month, value: month, to: lastPromptDate),
               currentDate >= nextPromptDate {
                userDefaults.set(currentDate, forKey: lastPromptDateKey)
                return true
            }
        case let .monthly(dayOfMonth):
            let nextPromptDateComponents = DateComponents(
                year: calendar.component(.year, from: currentDate),
                month: calendar.component(.month, from: currentDate),
                day: dayOfMonth
            )
            if let nextPromptDate = calendar.date(from: nextPromptDateComponents),
               currentDate >= nextPromptDate {
                userDefaults.set(currentDate, forKey: lastPromptDateKey)
                return true
            }
        case let .daily(everyXDays):
            if let nextPromptDate = calendar.date(byAdding: .day, value: everyXDays, to: lastPromptDate),
               currentDate >= nextPromptDate {
                userDefaults.set(currentDate, forKey: lastPromptDateKey)
                return true
            }
        case .weekly:
            if let nextPromptDate = calendar.date(byAdding: .day, value: 7, to: lastPromptDate),
               currentDate >= nextPromptDate {
                userDefaults.set(currentDate, forKey: lastPromptDateKey)
                return true
            }
        case .twoWeekly:
            if let nextPromptDate = calendar.date(byAdding: .day, value: 14, to: lastPromptDate),
               currentDate >= nextPromptDate {
                userDefaults.set(currentDate, forKey: lastPromptDateKey)
                return true
            }
        case .quarterly:
            if let nextPromptDate = calendar.date(byAdding: .month, value: 3, to: lastPromptDate),
               currentDate >= nextPromptDate {
                userDefaults.set(currentDate, forKey: lastPromptDateKey)
                return true
            }
        }
        return false
    }
}
