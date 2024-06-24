//
//  ACRuleCounter.swift
//
//
//  Created by Pavel Moslienko on 24.06.2024.
//

import Foundation

public class ACRuleCounter: ACRequestReviewRule {
    private let customFlagKey: String
    private let threshold: Int
    
    public init(customFlagKey: String, threshold: Int = 5) {
        self.customFlagKey = customFlagKey
        self.threshold = threshold
    }
    
    public func incrementFlag() {
        UserDefaultsHelper.shared.incrementNum(forKey: customFlagKey)
    }
    
    public var isShouldDisplayRating: Bool {
        let currentFlag: Int = UserDefaultsHelper.shared.get(forKey: customFlagKey) ?? 0
        
        if currentFlag >= threshold {
            UserDefaultsHelper.shared.set(0, forKey: customFlagKey)
            return true
        }
        
        return false
    }
}

#warning("Dev")
public class ACRuleAlways: ACRequestReviewRule {
    
    public var isShouldDisplayRating: Bool = true
    
    public init() {}
}
