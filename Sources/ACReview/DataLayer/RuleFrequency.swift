//
//  RuleFrequency.swift
//
//
//  Created by Pavel Moslienko on 24.06.2024.
//

import Foundation

public enum ActionFrequency {
    case onceYear
    case onceEveryMonths(month: Int)
    case monthly(dayOfMonth: Int)
    case daily(everyXDays: Int)
    
    var key: String {
        switch self {
        case .onceYear:
            return "ACReview_onceYear"
        case let .onceEveryMonths(month):
            return "ACReview_onceEveryMonths_\(month)"
        case let .monthly(dayOfMonth):
            return "ACReview_monthly_\(dayOfMonth)"
        case let .daily(everyXDays):
            return "ACReview_daily_\(everyXDays)"
        }
    }
}
