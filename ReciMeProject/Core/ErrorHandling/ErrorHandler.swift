//
//  ErrorHandler.swift
//  ReciMeProject
//
//  Created by Luis Pereira on 22/09/26.
//

import Foundation
import Combine

final class ErrorHandler {
    private let observability: ObservabilityManager
    let errorPublisher = PassthroughSubject<AppError, Never>()
    
    init(observability: ObservabilityManager) {
        self.observability = observability
    }
    
    func handle(
        _ error: Error,
        context: ErrorContext,
        presentToUser: Bool = true
    ) {
        let appError = convertToAppError(error)
        
        // Log the error
        observability.logger.error(
            appError.errorDescription ?? "Unknown error",
            category: "ErrorHandler",
            file: #file,
            function: #function,
            line: #line,
            metadata: [
                "screen": context.screen,
                "action": context.action,
                "user_id": context.userId ?? "N/A"
            ]
        )
        
        // Track error
        let trackedError = TrackedError(
            error: appError,
            context: context,
            isFatal: false
        )
        observability.errorTracker.track(error: trackedError)
        
        // Record metric
        observability.metrics.recordCounter(
            name: "error_occurred",
            value: 1.0,
            tags: [
                "screen": context.screen,
                "action": context.action,
                "error_type": String(describing: type(of: appError))
            ]
        )
        
        // Present to user if needed
        if presentToUser {
            errorPublisher.send(appError)
        }
    }
    
    private func convertToAppError(_ error: Error) -> AppError {
        if let appError = error as? AppError {
            return appError
        }
        
        // Convert common errors
        if (error as NSError).domain == NSURLErrorDomain {
            let code = (error as NSError).code
            switch code {
            case NSURLErrorNotConnectedToInternet:
                return .networkUnavailable
            case NSURLErrorTimedOut:
                return .timeout
            default:
                return .unknown(error: error)
            }
        }
        
        return .unknown(error: error)
    }
}
