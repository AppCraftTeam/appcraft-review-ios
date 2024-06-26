//
//  ACAppUpdateWithDelayRule.swift
//
//
//  Created by Pavel Moslienko on 26.06.2024.
//

import Foundation

// Показать запрос оценки через определенное время использования новой версии приложения
public class ACAppUpdateWithDelayRule: ACRequestStorage, ACRequestReviewRule {
    private let currentVersionKey = "ACReview_afterUpdateDelayRuleCurrentVersion"
    private let totalTimeKey: String = "ACReview_afterUpdateDelayRule_totalTime"
    private var sessionKey: String {
        totalTimeKey + "_session"
    }
    private let minimumUsageTime: TimeInterval
    
    public init(minimumUsageTimeInMinutes: TimeInterval) {
        self.minimumUsageTime = minimumUsageTimeInMinutes * 60
    }
    
    public func isNeedSetSession() -> Bool {
        guard let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return false
        }
        
        if let savedVersion: String = userDefaults.get(forKey: currentVersionKey) {
            return currentVersion != savedVersion
        }
        
        return false
    }
    
    public func startSession() {
        if isNeedSetSession() {
            userDefaults.set(Date().timeIntervalSince1970, forKey: sessionKey)
        }
    }
    
    public func endSession() {
        guard isNeedSetSession() else {
            return
        }
        let currentTime = Date().timeIntervalSince1970
        var startSeconds: Double = userDefaults.get(forKey: sessionKey) ?? 0.0
        let sessionTime = currentTime - startSeconds
        
        self.addToTotalTimeSpent(sessionTime)
    }
    
    public func getTotalSecondsSpent() -> TimeInterval {
        let value: Double = userDefaults.get(forKey: totalTimeKey) ?? 0.0
        return value
    }
    
    public var isShouldDisplayRating: Bool {
        let currentTimeSpent: TimeInterval = userDefaults.get(forKey: totalTimeKey) ?? 0
        if currentTimeSpent >= minimumUsageTime {
            userDefaults.set(0, forKey: totalTimeKey)
            userDefaults.remove(forKey: sessionKey)
            
            if let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                userDefaults.set(currentVersion, forKey: currentVersionKey)
            }
            
            return true
        }
        
        return false
    }
}

private extension ACAppUpdateWithDelayRule {
    
    func addToTotalTimeSpent(_ time: TimeInterval) {
        let totalTimeSpent: TimeInterval = userDefaults.get(forKey: totalTimeKey) ?? 0.0
        let newTotalTimeSpent = totalTimeSpent + time
        userDefaults.set(newTotalTimeSpent, forKey: totalTimeKey)
    }
}
