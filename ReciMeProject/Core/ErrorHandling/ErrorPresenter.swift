//
//  ErrorPresenter.swift
//  ReciMeProject
//
//  Created by Luis Pereira on 22/09/26.
//

import SwiftUI
import Combine

final class ErrorPresenter: ObservableObject {
    @Published var currentError: AppError?
    @Published var showError: Bool = false
    
    private let errorHandler: ErrorHandler
    private var cancellables = Set<AnyCancellable>()
    
    init(errorHandler: ErrorHandler) {
        self.errorHandler = errorHandler
        errorHandler.errorPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.presentError(error)
            }
            .store(in: &cancellables)
    }
    
    func presentError(_ error: AppError) {
        currentError = error
        showError = true
        
        // Auto-dismiss after 5 seconds for non-critical errors
        if error.severity <= .warning {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
                self?.dismissError()
            }
        }
    }
    
    func dismissError() {
        showError = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.currentError = nil
        }
    }
}
