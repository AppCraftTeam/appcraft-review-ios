//
//  Extension+Date.swift
//  ACReviewDemo
//
//  Created by Pavel Moslienko on 04.07.2024.
//

import Foundation

extension Date {
    
    func asString(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = dateStyle
        dateFormatter.timeStyle = dateStyle
        
        return dateFormatter.string(from: self)
    }
}
