//
//  ACReviewService.swift
//
//
//  Created by Pavel Moslienko on 24.06.2024.
//

import Foundation
import StoreKit

public protocol ACRequestReviewRule {
    var isShouldDisplayRating: Bool { get }
}

public class ACRequestStorage {
    let userDefaults = UserDefaultsHelper.shared
}

public class ACReviewService {
    private var rules: [ACRequestReviewRule]
    private var maxRequestCalls: Int?
    private var callsCounterService: ACReviewCallsCounterService
    
    public init(rule: ACRequestReviewRule, maxRequestCalls: Int? = nil) {
        self.rules = [rule]
        self.maxRequestCalls = maxRequestCalls
        self.callsCounterService = ACReviewCallsCounterService()
    }
    
    public init(rules: [ACRequestReviewRule], maxRequestCalls: Int? = nil) {
        self.rules = rules
        self.maxRequestCalls = maxRequestCalls
        self.callsCounterService = ACReviewCallsCounterService()
    }
    
    public func setRule(_ rule: ACRequestReviewRule) {
        self.rules = [rule]
    }
    
    public func setRules(_ rules: [ACRequestReviewRule]) {
        self.rules = rules
    }
    
    public func tryToShowRating(
        notRequiredFinished: (() -> Void)? = nil,
        requiredFinished: ((_ isPresented: Bool) -> Void)? = nil
    ) {
        guard let rule = rules.first(where: { $0.isShouldDisplayRating }) else {
            notRequiredFinished?()
            return
        }
        if let maxRequestCalls = maxRequestCalls {
            if callsCounterService.getCurrentAttempts() < maxRequestCalls {
                callReviewController(requiredFinished)
            } else {
                notRequiredFinished?()
            }
        } else {
            notRequiredFinished?()
        }
    }
}

private extension ACReviewService {
    
    func callReviewController(_ requiredFinished: ((Bool) -> Void)?) {
        if #available(iOS 14.0, *) {
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
                callsCounterService.incrementAttempt()
                ACReviewCallVerificationService.shared.startObserver { isPresented in
                    print("finsihed, isPresented - \(isPresented)")
                    requiredFinished?(isPresented)
                }
            }
        } else {
            SKStoreReviewController.requestReview()
            callsCounterService.incrementAttempt()
            ACReviewCallVerificationService.shared.startObserver { isPresented in
                print("finsihed, isPresented - \(isPresented)")
                requiredFinished?(isPresented)
            }
        }
    }
}
