//
//  ConsoleErrorProvider.swift
//  ReciMeProject
//
//  Created by Luis Pereira on 22/09/26.
//

import Foundation

protocol ErrorTrackingProvider {
    func track(error: TrackedError)
}

final class ConsoleErrorProvider: ErrorTrackingProvider {
    func track(error: TrackedError) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        let timestamp = formatter.string(from: error.timestamp)
        
        print("""
        🚨 [ERROR TRACKED] \(timestamp)
        Fatal: \(error.isFatal ? "YES" : "NO")
        Screen: \(error.context.screen)
        Action: \(error.context.action)
        Error: \(error.error.localizedDescription)
        User ID: \(error.context.userId ?? "N/A")
        Metadata: \(error.context.metadata)
        ---
        """)
    }
}
