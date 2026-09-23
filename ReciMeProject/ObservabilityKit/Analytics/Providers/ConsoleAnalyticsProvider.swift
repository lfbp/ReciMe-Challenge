//
//  ConsoleAnalyticsProvider.swift
//  ReciMeProject
//
//  Created by Luis Pereira on 22/09/26.
//

import Foundation

final class ConsoleAnalyticsProvider: AnalyticsProvider {
    func track(event: AnalyticsEvent) {
        let timestamp = ISO8601DateFormatter().string(from: Date())
        print("""
        📊 [ANALYTICS] \(timestamp)
        Event: \(event.name)
        Parameters: \(event.parameters)
        ---
        """)
    }
    
    func setUserProperty(key: String, value: String) {
        print("📊 [ANALYTICS] User Property Set: \(key) = \(value)")
    }
    
    func setUserId(_ userId: String) {
        print("📊 [ANALYTICS] User ID Set: \(userId)")
    }
    
    func resetUser() {
        print("📊 [ANALYTICS] User Reset")
    }
}
