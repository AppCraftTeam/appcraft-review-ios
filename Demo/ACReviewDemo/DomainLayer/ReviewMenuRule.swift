//
//  ReviewMenuRule.swift
//  ACReviewDemo
//
//  Created by Pavel Moslienko on 04.07.2024.
//

import Foundation

enum ReviewMenuRule: CaseIterable {
    case appUpdateRule, appUpdateWithDelayRule, eventDelayRule, timeSpentRule, ruleCounter, seriallyRule
    
    var title: String {
        switch self {
        case .appUpdateRule:
            return "ACAppUpdateRule"
        case .appUpdateWithDelayRule:
            return "ACAppUpdateWithDelayRule"
        case .eventDelayRule, .timeSpentRule:
            return "ACEventDelayRule"
        case .ruleCounter:
            return "ACRuleCounter"
        case .seriallyRule:
            return "ACSeriallyRule"
        }
    }
    
    var subtitle: String {
        switch self {
        case .appUpdateRule:
            return "Условие: установить новую версию приложения"
        case .appUpdateWithDelayRule:
            return "Условие: после установки новой версии приложения нужно провести 5 минут в приложении (суммарно)"
        case .eventDelayRule:
            return  "Условие: после нажатия на кнопку на сл.экране нужно провести 5 минут в приложении (суммарно)"
        case .timeSpentRule:
            return "Условие: провести 5 минут на сл.экране (суммарно)"
        case .ruleCounter:
            return "Условие: нажать кнопку на сл.экране 5 раз"
        case .seriallyRule:
            return "Условие: вызывать запрос на оценку каждые 2 дня"
        }
    }
}
