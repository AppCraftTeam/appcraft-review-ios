//
//  ACReviewCallVerificationService.swift
//
//
//  Created by Pavel Moslienko on 24.06.2024.
//

import UIKit
import StoreKit

class ACReviewCallVerificationService {
    
    static let shared = ACReviewCallVerificationService()
    var maxWaitingSeconds: Double = 5.0
    
    private var windowVisibleObserver: NSObjectProtocol?
    private var timer: Timer?
    private var callback: ((_ isPresented: Bool) -> Void)?
    
    private init() {}
    
    func startObserver(_ callback: @escaping (_ isPresented: Bool) -> Void) {
        self.callback = callback
        windowVisibleObserver = NotificationCenter.default.addObserver(
            forName: UIWindow.didBecomeVisibleNotification,
            object: nil,
            queue: nil
        ) { [weak self] _ in
            self?.handleWindowDidBecomeVisible()
        }
        startTimer()
    }
    
    func finishObserve() {
        if let observer = windowVisibleObserver {
            NotificationCenter.default.removeObserver(observer)
        }
        
        timer?.invalidate()
        timer = nil
        callback = nil
    }
}

private extension ACReviewCallVerificationService {
    
    func handleWindowDidBecomeVisible() {
        callback?(true)
        finishObserve()
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: maxWaitingSeconds, repeats: false) { [weak self] _ in
            self?.callback?(false)
            self?.finishObserve()
        }
    }
}
