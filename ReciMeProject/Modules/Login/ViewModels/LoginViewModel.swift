//
//  LoginViewModel.swift
//  ReciMeProject
//
//  Created by Luis Pereira on 22/09/26.
//

import Foundation
import Combine

final class LoginViewModel: BaseViewModel {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var loginState: LoginState = .idle
    @Published var errorMessage: String?
    
    enum LoginState: Equatable {
        case idle
        case loading
        case success(User)
        case failure(AppError)
        
        static func == (lhs: LoginState, rhs: LoginState) -> Bool {
            switch (lhs, rhs) {
            case (.idle, .idle), (.loading, .loading):
                return true
            case (.success(let lhsUser), .success(let rhsUser)):
                return lhsUser.id == rhsUser.id
            case (.failure(let lhsError), .failure(let rhsError)):
                return lhsError.localizedDescription == rhsError.localizedDescription
            default:
                return false
            }
        }
    }
    
    private let authService: AuthServiceProtocol
    private let observability: ObservabilityManager
    private let loginSubject = PassthroughSubject<Void, Never>()
    
    init(authService: AuthServiceProtocol, observability: ObservabilityManager) {
        self.authService = authService
        self.observability = observability
        super.init()
        setupBindings()
        observability.analytics.track(event: .screenViewed(screenName: "Login"))
        observability.impressions.trackImpression(
            contentId: "Login",
            contentType: "screen",
            metadata: [:]
        )
    }
    
    private func setupBindings() {
        loginSubject
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.isLoading = true
                self?.loginState = .loading
                self?.errorMessage = nil
            })
            .flatMap { [weak self] _ -> AnyPublisher<Result<User, AppError>, Never> in
                guard let self else {
                    return Just(.failure(.unknown(error: NSError(domain: "", code: -1)))).eraseToAnyPublisher()
                }
                
                let credentials = LoginCredentials(username: self.username, password: self.password)
                
                return self.authService.login(credentials: credentials)
                    .map { Result.success($0) }
                    .catch { Just(Result.failure($0)) }
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self else { return }
                self.isLoading = false
                switch result {
                case .success(let user):
                    self.loginState = .success(user)
                    self.observability.analytics.track(event: .userLogin(username: user.username))
                case .failure(let error):
                    self.loginState = .failure(error)
                    self.errorMessage = error.userFriendlyMessage
                }
            }
            .store(in: &cancellables)
    }
    
    func login() {
        guard !username.isEmpty && !password.isEmpty else {
            errorMessage = "Please enter username and password"
            return
        }
        loginSubject.send()
    }
    
    func resetError() {
        errorMessage = nil
    }
}
