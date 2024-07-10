//
//  ACActionFrequency.swift
//
//
//  Created by Pavel Moslienko on 24.06.2024.
//

import Foundation

/// Type for the frequency of the request review call
public enum ACActionFrequency {
    
    /// Annually
    case onceYear
    
    /// Every <x> months
    case onceEveryMonths(month: Int)
    
    /// Every month on the specified day of the month
    case monthly(dayOfMonth: Int)
    
    /// Daily with an interval of <x> days
    case daily(everyXDays: Int)
    
    /// Weekly
    case weekly
    
    /// Every two weeks
    case twoWeekly
    
    /// Quarterly
    case quarterly
    
    /// Unique key for UserDefaults
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
        case .weekly:
            return "ACReview_weekly"
        case .twoWeekly:
            return "ACReview_twoWeekly"
        case .quarterly:
            return "ACReview_quarterly"
        }
    }
}
