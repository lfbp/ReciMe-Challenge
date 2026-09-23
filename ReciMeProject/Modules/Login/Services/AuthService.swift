//
//  AuthService.swift
//  ReciMeProject
//
//  Created by Luis Pereira on 22/09/26.
//

import Foundation
import Combine

protocol AuthServiceProtocol {
    func login(credentials: LoginCredentials) -> AnyPublisher<User, AppError>
    func logout() -> AnyPublisher<Void, Never>
    func getCurrentUser() -> User?
}

final class MockAuthService: AuthServiceProtocol {
    private var currentUser: User?
    private let delay: TimeInterval
    
    init(delay: TimeInterval = 0.4) {
        self.delay = delay
    }
    
    func login(credentials: LoginCredentials) -> AnyPublisher<User, AppError> {
        let delay = self.delay
        return Future { promise in
            let work = {
                if credentials.isValid {
                    let user = User(
                        username: credentials.username,
                        email: "\(credentials.username)@recime.com"
                    )
                    promise(.success(user))
                } else {
                    promise(.failure(.authenticationFailed(reason: "Invalid credentials")))
                }
            }
            
            if delay > 0 {
                DispatchQueue.global().asyncAfter(deadline: .now() + delay, execute: work)
            } else {
                work()
            }
        }
        .handleEvents(receiveOutput: { [weak self] user in
            self?.currentUser = user
        })
        .eraseToAnyPublisher()
    }
    
    func logout() -> AnyPublisher<Void, Never> {
        currentUser = nil
        return Just(()).eraseToAnyPublisher()
    }
    
    func getCurrentUser() -> User? {
        return currentUser
    }
}
