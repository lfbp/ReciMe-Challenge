//
//  Coordinator.swift
//  ReciMeProject
//
//  Created by Luis Pereira on 22/09/26.
//

import Foundation

/// Minimal MVVM-C coordinator: owns a flow and can retain children.
protocol Coordinator: AnyObject {
    func start()
}

/// Optional parent that retains child coordinators for the flow lifetime.
protocol ParentCoordinator: Coordinator {
    var childCoordinators: [any Coordinator] { get set }
}

extension ParentCoordinator {
    func addChild(_ coordinator: any Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func removeChild(_ coordinator: any Coordinator) {
        childCoordinators.removeAll { $0 === coordinator as AnyObject }
    }
}
