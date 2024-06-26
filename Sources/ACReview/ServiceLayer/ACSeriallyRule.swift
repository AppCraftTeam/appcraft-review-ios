//
//  ACSeriallyRule.swift
//
//
//  Created by Pavel Moslienko on 26.06.2024.
//

import Foundation

public class ACSeriallyRule: ACRequestReviewRule {
    private let userDefaults = UserDefaultsHelper.shared
    private let actionFrequency: ActionFrequency
    
    public init(actionFrequency: ActionFrequency) {
        self.actionFrequency = actionFrequency
    }
    
    public var isShouldDisplayRating: Bool {
        let lastPromptDateKey = actionFrequency.key
        
        guard let lastPromptDate: Date = userDefaults.get(forKey: lastPromptDateKey) else {
            // App first launch date
            userDefaults.set(Date(), forKey: lastPromptDateKey)
            return false
        }
        
        let currentDate = Date()
        let calendar = Calendar.current
        
        switch actionFrequency {
        case .onceYear:
            if let nextPromptDate = calendar.date(
                byAdding: .year,
                value: 1,
                to: lastPromptDate
            ),
               currentDate >= nextPromptDate {
                userDefaults.set(currentDate, forKey: lastPromptDateKey)
                return true
            }
        case let .onceEveryMonths(month):
            if let nextPromptDate = calendar.date(
                byAdding: .month,
                value: month,
                to: lastPromptDate
            ),
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
            if let nextPromptDate = calendar.date(
                byAdding: .day,
                value: everyXDays,
                to: lastPromptDate
            ),
               currentDate >= nextPromptDate {
                userDefaults.set(currentDate, forKey: lastPromptDateKey)
                return true
            }
        }
        
        return false
    }
}
