//
//  ACReviewCallVerificationService.swift
//
//
//  Created by Pavel Moslienko on 24.06.2024.
//

import UIKit
import StoreKit

typealias ACCallServiceCallback = ((_ isPresented: Bool) -> Void)

/// A set of methods to verify the calling of the request alert after an attempt to open it
class ACReviewCallVerificationService {
    
    static let shared = ACReviewCallVerificationService()
    var maxWaitingSeconds: Double = 5.0
    
    private var windowVisibleObserver: NSObjectProtocol?
    private var timer: DispatchSourceTimer?
    private var callback: ACCallServiceCallback?
    
    private init() {}
    
    /*
     During the time interval after the request is called, the new window appear is monitored,
     which is most likely to be the review alert -> so the request is successful.
     If the event was not detected, the timer is cancelled and it is considered that the system did not allow the alert to be displayed.
     */
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
