//
//  ACRequestReviewRule.swift
//  
//
//  Created by Pavel Moslienko on 10.07.2024.
//

import Foundation

public protocol ACRequestReviewRule {
    func shouldDisplayRating(_ completion: @escaping (Bool) -> Void)
}
