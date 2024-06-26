//
//  ACTimeSpentRule.swift
//
//
//  Created by Pavel Moslienko on 25.06.2024.
//

import Foundation

public class ACTimeSpentRule: ACRequestStorage, ACRequestReviewRule {
    private let customFlagKey: String
    private var customFlagSessionKey: String {
        customFlagKey + "_session"
    }
    private let requiredTime: TimeInterval
    
    public init(customFlagKey: String, requiredTimeInMinutes: TimeInterval) {
        self.customFlagKey = customFlagKey
        self.requiredTime = requiredTimeInMinutes * 60
    }
    
    public func startSession() {
        userDefaults.set(Date().timeIntervalSince1970, forKey: customFlagSessionKey)
    }
    
    public func endSession() {
        let currentTime = Date().timeIntervalSince1970
        var startSeconds: Double = userDefaults.get(forKey: customFlagSessionKey) ?? 0.0
        let sessionTime = currentTime - startSeconds
        
        self.addToTotalTimeSpent(sessionTime)
    }
    
    public func getTotalSecondsSpent() -> TimeInterval {
        let value: Double = userDefaults.get(forKey: customFlagKey) ?? 0.0
        return value
    }
    
    public var isShouldDisplayRating: Bool {
        let currentTimeSpent: TimeInterval = userDefaults.get(forKey: customFlagKey) ?? 0
        if currentTimeSpent >= requiredTime {
            userDefaults.set(0, forKey: customFlagKey)
            return true
        }
        
        return false
    }
}

private extension ACTimeSpentRule {
    
    func addToTotalTimeSpent(_ time: TimeInterval) {
        let totalTimeSpent: TimeInterval = userDefaults.get(forKey: customFlagKey) ?? 0.0
        let newTotalTimeSpent = totalTimeSpent + time
        userDefaults.set(newTotalTimeSpent, forKey: customFlagKey)
    }
}
