//
//  View+Extensions.swift
//  ReciMeProject
//
//  Created by Luis Pereira on 22/09/26.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

extension View {
    func errorHandling(errorPresenter: ErrorPresenter) -> some View {
        self.overlay(alignment: .top) {
            if errorPresenter.showError, let error = errorPresenter.currentError {
                RMToast(
                    message: error.userFriendlyMessage,
                    type: errorTypeToToastType(error),
                    onDismiss: { errorPresenter.dismissError() }
                )
                .transition(.move(edge: .top).combined(with: .opacity))
                .animation(.spring(), value: errorPresenter.showError)
                .padding(.top, SpacingTokens.md)
                .zIndex(999)
            }
        }
    }
    
    /// Dismisses the software keyboard. Helps avoid Simulator keyboard constraint / haptic spam.
    func dismissKeyboard() {
        #if canImport(UIKit)
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
        #endif
    }
    
    private func errorTypeToToastType(_ error: AppError) -> RMToast.ToastType {
        switch error.severity {
        case .error, .critical:
            return .error
        case .warning:
            return .warning
        case .info:
            return .info
        default:
            return .info
        }
    }
}
