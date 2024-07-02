//
//  Bundle+Ext.swift
//
//
//  Created by Pavel Moslienko on 27.06.2024.
//

import Foundation

public extension Bundle {
    
    var currentVersion: String? {
        self.infoDictionary?["CFBundleShortVersionString"] as? String
    }
}
