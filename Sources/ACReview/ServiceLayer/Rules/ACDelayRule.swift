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
public protocol ACDelayRule: ACRequestStorage {
    var isActiveCondition: Bool { get }
    var totalTimeKey: String { get set }
    var sessionKey: String { get }
    var minimumUsageTime: TimeInterval { get set }
    
    func setCondition(_ val: Bool)
    func startSession()
    func endSession()
}

public extension ACDelayRule {
    
    func startSession() {
        if isActiveCondition {
            userDefaults.set(Date().timeIntervalSince1970, forKey: sessionKey)
        }
    }
    
    func endSession() {
        guard isActiveCondition else {
            return
        }
        let currentTime = Date().timeIntervalSince1970
        var startSeconds: Double = userDefaults.get(forKey: sessionKey) ?? 0.0
        let sessionTime = currentTime - startSeconds
        
        self.addToTotalTimeSpent(sessionTime)
    }
}

private extension ACDelayRule {
    
    func addToTotalTimeSpent(_ time: TimeInterval) {
        let totalTimeSpent: TimeInterval = userDefaults.get(forKey: totalTimeKey) ?? 0.0
        let newTotalTimeSpent = totalTimeSpent + time
        userDefaults.set(newTotalTimeSpent, forKey: totalTimeKey)
    }
}
