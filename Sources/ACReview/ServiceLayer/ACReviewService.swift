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

open class ACReviewService {
    private var rules: [ACRequestReviewRule]
    private var maxRequestCalls: Int?
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
            requiredFinished?(isPresented)
        }
    }
}
