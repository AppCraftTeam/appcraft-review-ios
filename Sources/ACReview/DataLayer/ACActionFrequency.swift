//
//  ACActionFrequency.swift
//
//
//  Created by Pavel Moslienko on 24.06.2024.
//

import Foundation

public enum ACActionFrequency {
    /// Ежегодно
    case onceYear
    /// Каждые <x> месяцев
    case onceEveryMonths(month: Int)
    /// Ежемесечно в указанный день недели
    case monthly(dayOfMonth: Int)
    /// Ежедневно с промежутком в <x> дней
    case daily(everyXDays: Int)
    /// Еженедельно
    case weekly
    /// Ежеквартально
    case quarterly
    ////// Раз в две недели
    case twoWeekly
    
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
        case .quarterly:
            return "ACReview_quarterly"
        case .twoWeekly:
            return "ACReview_twoWeekly"
        }
    }
}
