//
//  LoginView.swift
//  ReciMeProject
//
//  Created by Luis Pereira on 22/09/26.
//

import SwiftUI

struct LoginView: View {
    @StateObject var viewModel: LoginViewModel
    @EnvironmentObject var errorPresenter: ErrorPresenter
    @FocusState private var focusedField: Field?
    
    private enum Field {
        case username, password
    }
    
    init(viewModel: LoginViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: SpacingTokens.xl) {
            Spacer()
            
            Image(systemName: "fork.knife.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(ColorTokens.primary)
            
            Text("ReciMe")
                .font(TypographyTokens.largeTitle)
                .foregroundColor(ColorTokens.textPrimary)
            
            Text("Discover amazing recipes")
                .font(TypographyTokens.body)
                .foregroundColor(ColorTokens.textSecondary)
            
            Spacer()
            
            VStack(spacing: SpacingTokens.md) {
                RMTextField(
                    placeholder: "Username",
                    text: $viewModel.username,
                    icon: "person",
                    errorMessage: viewModel.errorMessage
                )
                .focused($focusedField, equals: .username)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                
                RMSecureField(
                    placeholder: "Password",
                    text: $viewModel.password,
                    icon: "lock"
                )
                .focused($focusedField, equals: .password)
                
                RMButton(
                    title: "Login",
                    style: .primary,
                    action: {
                        // Dismiss keyboard before transition to avoid Simulator
                        // keyboard constraint / haptic noise.
                        focusedField = nil
                        dismissKeyboard()
                        viewModel.login()
                    },
                    isLoading: viewModel.isLoading
                )
            }
            
            Spacer()
        }
        .padding(SpacingTokens.lg)
        .background(ColorTokens.background)
        .contentShape(Rectangle())
        .onTapGesture {
            focusedField = nil
            dismissKeyboard()
        }
    }
}

#Preview {
    let mockObs = ObservabilityManager()
    let mockErrorHandler = ErrorHandler(observability: mockObs)
    
    LoginView(
        viewModel: LoginViewModel(authService: MockAuthService(), observability: mockObs)
    )
    .environmentObject(ErrorPresenter(errorHandler: mockErrorHandler))
}
