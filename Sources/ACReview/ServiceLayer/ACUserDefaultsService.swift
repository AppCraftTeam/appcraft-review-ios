//
//  ACUserDefaultsService.swift
//
//
//  Created by Pavel Moslienko on 21.06.2024.
//

import Foundation

public class ACUserDefaultsService {
    
    public static let shared = ACUserDefaultsService()
    private let userDefaults = UserDefaults.standard
    
    private init() {}
    
    public func set<T>(_ value: T, forKey key: String) {
        userDefaults.set(value, forKey: key)
    }
    
    public func get<T>(forKey key: String) -> T? {
        return userDefaults.object(forKey: key) as? T
    }
    
    public func remove(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }
    
    public func incrementNum(forKey key: String) {
        var currentValue = userDefaults.integer(forKey: key)
        currentValue += 1
        userDefaults.set(currentValue, forKey: key)
    }
}
