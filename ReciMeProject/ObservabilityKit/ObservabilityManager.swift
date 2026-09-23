//
//  ObservabilityManager.swift
//  ReciMeProject
//
//  Created by Luis Pereira on 22/09/26.
//

import Foundation

final class ObservabilityManager {
    let analytics: AnalyticsEngineProtocol
    let logger: LoggerProtocol
    let errorTracker: ErrorTrackerProtocol
    let metrics: MetricsCollectorProtocol
    let impressions: ImpressionTrackerProtocol
    
    init() {
        // Initialize analytics
        self.analytics = AnalyticsEngine(providers: [
            ConsoleAnalyticsProvider()
        ])
        
        // Initialize logger
        self.logger = Logger.shared
        
        // Initialize error tracker
        self.errorTracker = ErrorTracker(providers: [
            ConsoleErrorProvider()
        ])
        
        // Initialize metrics
        self.metrics = MetricsCollector()
        
        // Initialize impression tracker
        self.impressions = ImpressionTracker(analyticsEngine: analytics)
    }
    
    func configure() {
        // Ready for analytics/logging providers; keep quiet by default.
    }
}
