//
//  ACTimeSpentRule.swift
//
//
//  Created by Pavel Moslienko on 25.06.2024.
//

import Foundation

public class ACTimeSpentRule: ACRequestReviewRule {
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
        UserDefaultsHelper.shared.set(Date().timeIntervalSince1970, forKey: customFlagSessionKey)
    }
    
    public func endSession() {
        let currentTime = Date().timeIntervalSince1970
        var startSeconds: Double = UserDefaultsHelper.shared.get(forKey: customFlagSessionKey) ?? 0.0
        let sessionTime = currentTime - startSeconds
        
        self.addToTotalTimeSpent(sessionTime)
    }
    
    public func getTotalSecondsSpent() -> TimeInterval {
        let value: Double = UserDefaultsHelper.shared.get(forKey: customFlagKey) ?? 0.0
        return value
    }
    
    public var isShouldDisplayRating: Bool {
        let currentTimeSpent: TimeInterval = UserDefaultsHelper.shared.get(forKey: customFlagKey) ?? 0
        if currentTimeSpent >= requiredTime {
            UserDefaultsHelper.shared.set(0, forKey: customFlagKey)
            return true
        }
        
        return false
    }
}

private extension ACTimeSpentRule {
    
    func addToTotalTimeSpent(_ time: TimeInterval) {
        let totalTimeSpent: TimeInterval = UserDefaultsHelper.shared.get(forKey: customFlagKey) ?? 0.0
        let newTotalTimeSpent = totalTimeSpent + time
        UserDefaultsHelper.shared.set(newTotalTimeSpent, forKey: customFlagKey)
    }
}
