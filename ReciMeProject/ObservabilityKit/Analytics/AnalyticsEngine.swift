//
//  AnalyticsEngine.swift
//  ReciMeProject
//
//  Created by Luis Pereira on 22/09/26.
//

import Foundation

protocol AnalyticsEngineProtocol {
    func track(event: AnalyticsEvent)
    func setUserProperty(key: String, value: String)
    func identify(userId: String)
    func reset()
}

final class AnalyticsEngine: AnalyticsEngineProtocol {
    private let providers: [AnalyticsProvider]
    private let queue: DispatchQueue
    
    init(providers: [AnalyticsProvider]) {
        self.providers = providers
        self.queue = DispatchQueue(label: "com.recime.analytics", qos: .utility)
    }
    
    func track(event: AnalyticsEvent) {
        queue.async { [weak self] in
            self?.providers.forEach { provider in
                provider.track(event: event)
            }
        }
    }
    
    func setUserProperty(key: String, value: String) {
        queue.async { [weak self] in
            self?.providers.forEach { provider in
                provider.setUserProperty(key: key, value: value)
            }
        }
    }
    
    func identify(userId: String) {
        queue.async { [weak self] in
            self?.providers.forEach { provider in
                provider.setUserId(userId)
            }
        }
    }
    
    func reset() {
        queue.async { [weak self] in
            self?.providers.forEach { provider in
                provider.resetUser()
            }
        }
    }
}
