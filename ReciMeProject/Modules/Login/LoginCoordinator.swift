import SwiftUI
import Combine

final class LoginCoordinator: Coordinator {
    var onLoginSuccess: ((User) -> Void)?
    
    private let dependencies: LoginDependencies
    private(set) var viewModel: LoginViewModel?
    private var cancellables = Set<AnyCancellable>()
    
    init(dependencies: LoginDependencies) {
        self.dependencies = dependencies
    }
    
    func start() {
        let viewModel = LoginViewModel(
            authService: dependencies.authService,
            observability: dependencies.observability
        )
        self.viewModel = viewModel
        
        viewModel.$loginState
            .compactMap { state -> User? in
                if case .success(let user) = state { return user }
                return nil
            }
            .sink { [weak self] user in
                self?.onLoginSuccess?(user)
            }
            .store(in: &cancellables)
    }
}
