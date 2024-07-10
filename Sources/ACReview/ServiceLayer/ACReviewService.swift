//
//  ACReviewService.swift
//
//
//  Created by Pavel Moslienko on 24.06.2024.
//

import Foundation
import StoreKit

public protocol ACRequestReviewRule {
    func shouldDisplayRating(_ completion: @escaping (Bool) -> Void)
}

/// A set of methods for working with review rules
open class ACReviewService {
    private var rules: [ACRequestReviewRule]
    private var maxRequestCalls: Int?
    
    /// Key for UserDefault to saving the date of last opening review alert
    private var reviewLastDateKey = "ACReview_review_last_call_date"
    
    open private(set) var reviewLastCallDate: Date? {
        get {
            let savedValue: Date? = ACUserDefaultsService.shared.get(forKey: reviewLastDateKey)
            return savedValue
        }
        set {
            ACUserDefaultsService.shared.set(newValue, forKey: reviewLastDateKey)
        }
    }
    
    open var callsCounterService: ACReviewCallsCounter
    
    public init(rules: [ACRequestReviewRule], maxRequestCalls: Int? = nil, callsCounterService: ACReviewCallsCounter = ACReviewCallsCounterService()) {
        self.rules = rules
        self.maxRequestCalls = maxRequestCalls
        self.callsCounterService = callsCounterService
    }
    
    public convenience init(rule: ACRequestReviewRule, maxRequestCalls: Int? = nil, callsCounterService: ACReviewCallsCounter = ACReviewCallsCounterService()) {
        self.init(rules: [rule], maxRequestCalls: maxRequestCalls, callsCounterService: callsCounterService)
    }
    
    open func setRule(_ rule: ACRequestReviewRule) {
        self.rules = [rule]
    }
    
    open func setRules(_ rules: [ACRequestReviewRule]) {
        self.rules = rules
    }
    
    // Check the conditions of all rules and call the review alert if at least one rule allows it
    open func tryToShowRating(
        notRequiredFinished: (() -> Void)? = nil,
        requiredFinished: ((_ isPresented: Bool) -> Void)? = nil
    ) {
        let dispatchGroup = DispatchGroup()
        var shouldDisplay = false
        
        for rule in rules {
            if shouldDisplay {
                break
            }
            dispatchGroup.enter()
            rule.shouldDisplayRating { result in
                if result {
                    /// If one rule allows an alert to be call, the other rules are not checked
                    shouldDisplay = true
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            guard shouldDisplay else {
                notRequiredFinished?()
                return
            }
            
            /// Checking the limit on the maximum number of calls the review alert
            if let maxRequestCalls = self.maxRequestCalls {
                if self.callsCounterService.getCurrentAttempts() < maxRequestCalls {
                    self.callReviewController(requiredFinished)
                } else {
                    notRequiredFinished?()
                }
            } else {
                self.callReviewController(requiredFinished)
            }
        }
    }
}

private extension ACReviewService {
    
    /// Method for calling the review alert
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
    
    /// Attempt to verify the call attempt and save information about it
    func processingAttemptCallRequest(_ requiredFinished: ((Bool) -> Void)?) {
        callsCounterService.incrementAttempt()
        reviewLastCallDate = Date()
        ACReviewCallVerificationService.shared.startObserving { isPresented in
            requiredFinished?(isPresented)
        }
    }
}
