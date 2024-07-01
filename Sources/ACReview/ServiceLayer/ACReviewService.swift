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
    private var reviewLastDateKey = "ACReview_review_last_call_date"
    
    public private(set) var reviewLastCallDate: Date? {
        get {
            let savedValue: Date? = UserDefaultsHelper.shared.get(forKey: reviewLastDateKey)
            return savedValue
        }
        set {
            UserDefaultsHelper.shared.set(newValue, forKey: reviewLastDateKey)
        }
    }
    
    public init(rules: [ACRequestReviewRule], maxRequestCalls: Int? = nil) {
        self.rules = rules
        self.maxRequestCalls = maxRequestCalls
        self.callsCounterService = ACReviewCallsCounterService()
    }
    
    public convenience init(rule: ACRequestReviewRule, maxRequestCalls: Int? = nil) {
        self.init(rules: [rule], maxRequestCalls: maxRequestCalls)
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
                processingAttemptCallRequest(requiredFinished)
            }
        } else {
            SKStoreReviewController.requestReview()
            processingAttemptCallRequest(requiredFinished)
        }
    }
    
    func processingAttemptCallRequest(_ requiredFinished: ((Bool) -> Void)?) {
        callsCounterService.incrementAttempt()
        reviewLastCallDate = Date()
        ACReviewCallVerificationService.shared.startObserving { isPresented in
            print("finsihed, isPresented - \(isPresented)")
            requiredFinished?(isPresented)
        }
    }
}
