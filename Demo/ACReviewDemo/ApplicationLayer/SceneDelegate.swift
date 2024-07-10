//
//  SceneDelegate.swift
//  ACReviewDemo
//
//  Created by Дмитрий Поляков on 22.08.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    // MARK: - Props
    var window: UIWindow?
    
    private lazy var appCoordiantor: AppCoordinator = {
        AppCoordinator(window: self.window)
    }()
    
    // MARK: - Methods
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        self.window = UIWindow(windowScene: windowScene)
        self.appCoordiantor.start()
        
    }
}
