//
//  ACAppUpdateRule.swift
//
//
//  Created by Pavel Moslienko on 26.06.2024.
//

import Foundation

public class ACAppUpdateRule: ACRequestReviewRule {
    private let currentVersionKey = "ACReview_afterUpdateRuleCurrentVersion"
    
    public init() {}
    
    public var isShouldDisplayRating: Bool {
        guard let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return false
        }
        
        if let savedVersion: String = UserDefaultsHelper.shared.get(forKey: currentVersionKey) {
            if currentVersion != savedVersion {
                UserDefaultsHelper.shared.set(currentVersion, forKey: currentVersionKey)
                return true
            }
            return false
        }
        
        UserDefaultsHelper.shared.set(currentVersion, forKey: currentVersionKey)
        
        return false
    }
}
