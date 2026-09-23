//
//  ImpressionTracker.swift
//  ReciMeProject
//
//  Created by Luis Pereira on 22/09/26.
//

import Foundation

protocol ImpressionTrackerProtocol {
    func trackImpression(contentId: String, contentType: String, metadata: [String: Any])
}

final class ImpressionTracker: ImpressionTrackerProtocol {
    private let analyticsEngine: AnalyticsEngineProtocol
    private var trackedImpressions: Set<String> = []
    
    init(analyticsEngine: AnalyticsEngineProtocol) {
        self.analyticsEngine = analyticsEngine
    }
    
    func trackImpression(contentId: String, contentType: String, metadata: [String: Any] = [:]) {
        let impressionKey = "\(contentType)_\(contentId)"
        
        // Track only once per session
        guard !trackedImpressions.contains(impressionKey) else { return }
        
        trackedImpressions.insert(impressionKey)
        
        var parameters: [String: Any] = [
            "content_id": contentId,
            "content_type": contentType
        ]
        parameters.merge(metadata) { _, new in new }
        
        analyticsEngine.track(event: .custom(name: "impression", parameters: parameters))
    }
}
