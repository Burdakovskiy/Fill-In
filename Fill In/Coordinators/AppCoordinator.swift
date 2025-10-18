//
//  AppCoordinator.swift
//  Fill In
//
//  Created by Дмитрий on 16.10.2025.
//

import UIKit

final class AppCoordinator: BaseCoordinator {
    private let window: UIWindow
    private let diContained: AppDIContainer
    
    init(window: UIWindow, navigationController: UINavigationController) {
        self.window = window
        self.diContained = AppDIContainer()
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        showMainFlow()
    }
}

private extension AppCoordinator {
    func showLoginFlow() {
        
    }
    
    func showBiometricFlowIfNeeded() {
        
    }
    
    func showMainFlow() {
        let tabBarCoordinator = TabBarCoordinator(diContainer: diContained)
        addChildCoordinator(tabBarCoordinator)
        tabBarCoordinator.start()
        
        window.rootViewController = tabBarCoordinator.getRootViewController()
    }
}
