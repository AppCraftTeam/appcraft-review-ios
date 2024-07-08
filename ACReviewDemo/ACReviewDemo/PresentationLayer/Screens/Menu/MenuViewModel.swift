//
//  MenuViewModel.swift
//  ACReviewDemo
//
//  Created by Pavel Moslienko on 03.07.2024.
//

import Foundation

final class MenuViewModel {
    
    let rules = ReviewMenuRule.allCases
    var didOpenRuleScreen: ((_ ruleItem: ReviewMenuRule) -> Void)?

    func handleRule(_ ruleItem: ReviewMenuRule) {
        didOpenRuleScreen?(ruleItem)
    }
}
