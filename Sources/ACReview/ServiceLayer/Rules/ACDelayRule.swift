//
//  ACDelayRule.swift
//  
//
//  Created by Pavel Moslienko on 27.06.2024.
//

import Foundation

/// Show an evaluation request after a specified period of time of using the app after an action has been performed
public protocol ACDelayRule {
    /// Does the rule have active status, i.e. is it allowed to record the time spent in sessions
    var isActiveCondition: Bool { get }
    /// A unique key for UserDefault to save the total time of all sessions
    var totalTimeKey: String { get set }
    /// Unique key for UserDefault to save the start time of the current session recording
    var sessionKey: String { get }
    /// Minimum number of total seconds in sessions to allow to show the review alert
    var minimumUsageTime: TimeInterval { get set }
    /// Make the rule active to be able to record sessions or inactive
    func setCondition(_ val: Bool)
    /// Save the start time of the session recording if the rule is active
    func startSession()
    /// End the session and save the time spent from the beginning of the recording to its end, if the rule is active
    func endSession()
    /// Delete the time of the saved and recorded sessions
    func resetTime()
    /// Get the total duration of the session, including the session not yet completed
    func getTotalSecondsSpent() -> TimeInterval
    /// Get the duration of the previous saved and completed session
    func getSavedSecondsSpent() -> TimeInterval
    /// Get the duration of the current session
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
    
    func getTotalSecondsSpent() -> TimeInterval {
        getSavedSecondsSpent() + getSessionSpent()
    }
    
    func getSavedSecondsSpent() -> TimeInterval {
        let value: TimeInterval = ACUserDefaultsService.shared.get(forKey: totalTimeKey) ?? 0.0
        return value
    }
    
    func getSessionSpent() -> TimeInterval {
        guard isActiveCondition else {
            return 0.0
        }
        let currentTime = Date().timeIntervalSince1970
        let startSeconds: Double = ACUserDefaultsService.shared.get(forKey: sessionKey) ?? 0.0
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
