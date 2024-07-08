//
//  ACDelayRule.swift
//  
//
//  Created by Pavel Moslienko on 27.06.2024.
//

import Foundation

/* Показать запрос оценки через определенное время использования приложения после совершения какого-либо действия,
 пример - после того как перешли на определенный экран или выполнили определенное действие сохранить isActiveCondition,
 после чего по условию нужно еще 5 минут пользоваться приложением (minimumUsageTime) (время сохраняется между закрытием приложения)
 */
public protocol ACDelayRule {
    var isActiveCondition: Bool { get }
    var totalTimeKey: String { get set }
    var sessionKey: String { get }
    var minimumUsageTime: TimeInterval { get set }
    
    func setCondition(_ val: Bool)
    func startSession()
    func endSession()
    func getTotalSecondsSpent() -> TimeInterval
    func getSavedSecondsSpent() -> TimeInterval
    func getSessionSpent() -> TimeInterval
}

public extension ACDelayRule {
    
    func startSession() {
        if isActiveCondition {
            ACUserDefaultsService.shared.set(Date().timeIntervalSince1970, forKey: sessionKey)
        }
    }
    
    func endSession() {
        guard isActiveCondition else {
            return
        }
        let sessionTime = getSessionSpent()
        addToTotalTimeSpent(sessionTime)
    }
    
    func getSavedSecondsSpent() -> TimeInterval {
        let value: TimeInterval = ACUserDefaultsService.shared.get(forKey: totalTimeKey) ?? 0.0
        return value
    }
    
    func getTotalSecondsSpent() -> TimeInterval {
        getSavedSecondsSpent() + getSessionSpent()
    }
    
    func getSessionSpent() -> TimeInterval {
        guard isActiveCondition else {
            return 0.0
        }
        let currentTime = Date().timeIntervalSince1970
        var startSeconds: Double = ACUserDefaultsService.shared.get(forKey: sessionKey) ?? 0.0
        let sessionTime = currentTime - startSeconds
        
        return sessionTime
    }
    
    func resetTime() {
        ACUserDefaultsService.shared.set(0, forKey: totalTimeKey)
        ACUserDefaultsService.shared.remove(forKey: sessionKey)
    }
}

private extension ACDelayRule {
    
    func addToTotalTimeSpent(_ time: TimeInterval) {
        let totalTimeSpent = getTotalSecondsSpent()
        ACUserDefaultsService.shared.set(totalTimeSpent, forKey: totalTimeKey)
    }
    
}
