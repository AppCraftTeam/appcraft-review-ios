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

public class ACReviewService {
    private var rule: ACRequestReviewRule
    
    public init(rule: ACRequestReviewRule) {
        self.rule = rule
    }
    
    public func setRule(_ rule: ACRequestReviewRule) {
        self.rule = rule
    }
    
    public func tryToShowRating(
        notRequiredFinished: (() -> Void)? = nil,
        requiredFinished: ((_ isPresented: Bool) -> Void)? = nil
    ) {
        guard rule.isShouldDisplayRating else {
            notRequiredFinished?()
            return
        }
        if #available(iOS 14.0, *) {
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
                ACReviewCallVerificationService.shared.startObserver { isPresented in
                    print("finsihed, isPresented - \(isPresented)")
                    requiredFinished?(isPresented)
                }
            }
        } else {
            SKStoreReviewController.requestReview()
            ACReviewCallVerificationService.shared.startObserver { isPresented in
                print("finsihed, isPresented - \(isPresented)")
                requiredFinished?(isPresented)
            }
        }
    }
}

