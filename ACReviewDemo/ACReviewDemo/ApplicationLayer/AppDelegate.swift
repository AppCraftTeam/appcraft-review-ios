//
//  AppDelegate.swift
//  ACReviewDemo
//
//  Created by Дмитрий Поляков on 22.08.2022.
//

import ACReview
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        saveSessions()
    }
    
    private func saveSessions() {
        // Проверка что сессия начата происходит уже внутри функции поэтому isActiveCondition можно не проверять
        ACEventDelayRule(key: AppKeys.eventDelayRuleKey, minimumUsageTime: 5).endSession()
        ACAppUpdateWithDelayRule(minimumUsageTimeInMinutes: 5).endSession()
    }
}
