//
//  ACUserDefaultsService.swift
//
//
//  Created by Pavel Moslienko on 21.06.2024.
//

import Foundation

/// A wrapper to work with UserDefaults
open class ACUserDefaultsService {
    
    public static let shared = ACUserDefaultsService()
    private let userDefaults = UserDefaults.standard
    
    private init() {}
    
    open func set<T>(_ value: T, forKey key: String) {
        userDefaults.set(value, forKey: key)
    }
    
    open func get<T>(forKey key: String) -> T? {
        return userDefaults.object(forKey: key) as? T
    }
    
    open func remove(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }
    
    open func incrementNum(forKey key: String) {
        var currentValue = userDefaults.integer(forKey: key)
        currentValue += 1
        userDefaults.set(currentValue, forKey: key)
    }
}
