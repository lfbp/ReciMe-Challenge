//
//  TrackedError.swift
//  ReciMeProject
//
//  Created by Luis Pereira on 22/09/26.
//

import Foundation

struct TrackedError {
    let error: Error
    let context: ErrorContext
    let timestamp: Date
    let isFatal: Bool
    
    init(error: Error, context: ErrorContext, isFatal: Bool = false) {
        self.error = error
        self.context = context
        self.timestamp = Date()
        self.isFatal = isFatal
    }
}

struct ErrorContext {
    let screen: String
    let action: String
    let userId: String?
    let metadata: [String: Any]
    
    init(
        screen: String,
        action: String,
        userId: String? = nil,
        metadata: [String: Any] = [:]
    ) {
        self.screen = screen
        self.action = action
        self.userId = userId
        self.metadata = metadata
    }
}
