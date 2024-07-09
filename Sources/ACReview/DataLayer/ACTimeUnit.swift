//
//  ACTimeUnit.swift
//
//
//  Created by Pavel Moslienko on 05.07.2024.
//

import Foundation

/// Enum wrapper for creating milliseconds
public enum ACTimeUnit {
    case seconds(Int)
    case minutes(Int)
    case hours(Int)
    case days(Int)
    
    public var secondsTimeInterval: TimeInterval {
        switch self {
        case let .seconds(value):
            return TimeInterval(value)
        case let .minutes(value):
            return TimeInterval(value * 60)
        case let .hours(value):
            return TimeInterval(value * 3600)
        case let .days(value):
            return TimeInterval(value * 86400)
        }
    }
}
