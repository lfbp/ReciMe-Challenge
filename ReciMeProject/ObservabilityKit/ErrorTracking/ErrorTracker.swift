//
//  ErrorTracker.swift
//  ReciMeProject
//
//  Created by Luis Pereira on 22/09/26.
//

import Foundation

protocol ErrorTrackerProtocol {
    func track(error: TrackedError)
    func trackCrash(error: Error, context: ErrorContext)
}

final class ErrorTracker: ErrorTrackerProtocol {
    private let providers: [ErrorTrackingProvider]
    private let queue: DispatchQueue
    
    init(providers: [ErrorTrackingProvider]) {
        self.providers = providers
        self.queue = DispatchQueue(label: "com.recime.errortracker", qos: .utility)
    }
    
    func track(error: TrackedError) {
        queue.async { [weak self] in
            self?.providers.forEach { provider in
                provider.track(error: error)
            }
        }
    }
    
    func trackCrash(error: Error, context: ErrorContext) {
        let trackedError = TrackedError(error: error, context: context, isFatal: true)
        track(error: trackedError)
    }
}
