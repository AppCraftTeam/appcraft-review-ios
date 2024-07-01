//
//  ACSeriallyRule.swift
//
//
//  Created by Pavel Moslienko on 26.06.2024.
//

import Foundation

public class ACSeriallyRule: ACRequestStorage, ACRequestReviewRule {
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
        
        let isShouldCallRating = isShouldCallRating(
            with: actionFrequency,
            lastPromptDate: lastPromptDate,
            lastPromptDateKey: lastPromptDateKey
        )
        
        return isShouldCallRating
    }
}

private extension ACSeriallyRule {
    
    func isShouldCallRating(with actionFrequency: ActionFrequency, lastPromptDate: Date, lastPromptDateKey: String) -> Bool {
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
        case .quarterly:
            if let nextPromptDate = calendar.date(byAdding: .month, value: 3, to: lastPromptDate),
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
        }
        return false
    }
}
