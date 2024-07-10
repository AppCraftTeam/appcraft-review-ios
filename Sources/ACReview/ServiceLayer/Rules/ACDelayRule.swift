//
//  ACDelayRule.swift
//  
//
//  Created by Pavel Moslienko on 27.06.2024.
//

import Foundation

/// Show an evaluation request after a specified period of time of using the app after an action has been performed
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
    
    /// Get the duration of the previous saved and completed session
    func getSavedSecondsSpent() -> TimeInterval {
        let value: TimeInterval = ACUserDefaultsService.shared.get(forKey: totalTimeKey) ?? 0.0
        return value
    }
    
    /// Get the total duration of the session, including the session not yet completed
    func getTotalSecondsSpent() -> TimeInterval {
        getSavedSecondsSpent() + getSessionSpent()
    }
    
    /// Get the duration of the current session
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
    
    /// Save current session time
    func addToTotalTimeSpent(_ time: TimeInterval) {
        let totalTimeSpent = getTotalSecondsSpent()
        ACUserDefaultsService.shared.set(totalTimeSpent, forKey: totalTimeKey)
    }
}
