//
//  ACReviewCallVerificationService.swift
//
//
//  Created by Pavel Moslienko on 24.06.2024.
//

import UIKit
import StoreKit

typealias ACCallServiceCallback = ((_ isPresented: Bool) -> Void)

class ACReviewCallVerificationService {
    
    static let shared = ACReviewCallVerificationService()
    var maxWaitingSeconds: Double = 5.0
    
    private var windowVisibleObserver: NSObjectProtocol?
    private var timer: DispatchSourceTimer?
    private var callback: ACCallServiceCallback?
    
    private init() {}
    
    func startObserving(callback: @escaping ACCallServiceCallback) {
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
    
    func stopObserving() {
        if let observer = windowVisibleObserver {
            NotificationCenter.default.removeObserver(observer)
            windowVisibleObserver = nil
        }
        
        timer?.cancel()
        timer = nil
        callback = nil
    }
}

private extension ACReviewCallVerificationService {
    
    func handleWindowDidBecomeVisible() {
        callback?(true)
        stopObserving()
    }
    
    func startTimer() {
        timer = DispatchSource.makeTimerSource()
        timer?.schedule(deadline: .now() + maxWaitingSeconds)
        timer?.setEventHandler { [weak self] in
            self?.callback?(false)
            self?.stopObserving()
        }
        timer?.resume()
    }
}
