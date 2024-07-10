//
//  Extension+Double.swift
//  ACReviewDemo
//
//  Created by Pavel Moslienko on 08.07.2024.
//

import Foundation

extension Double {
    
    func asString(style: DateComponentsFormatter.UnitsStyle) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second, .nanosecond]
        formatter.unitsStyle = style
        
        return formatter.string(from: self) ?? ""
    }
}
