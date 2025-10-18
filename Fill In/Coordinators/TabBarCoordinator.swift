//
//  TabBarCoordinator.swift
//  Fill In
//
//  Created by Дмитрий on 16.10.2025.
//

import UIKit

final class TabBarCoordinator: BaseCoordinator {
    
    private let tabBarController = MainTabBarController()
    private let tasksCoordinator: TasksCoordinator
    private let statsCoordinator: StatsCoordinator
    
    init() {
        tasksCoordinator = TasksCoordinator(navigationController: UINavigationController())
        statsCoordinator = StatsCoordinator(navigationController: UINavigationController())
        super.init(navigationController: UINavigationController())
    }
    
    override func start() {
        tasksCoordinator.start()
        statsCoordinator.start()
        
        let tasksNav = tasksCoordinator.navigationController
        tasksNav.tabBarItem = UITabBarItem(title: "Tasks",
                                           image: UIImage(systemName: "checkmark.circle"),
                                           selectedImage: UIImage(systemName: "checkmark.circle.fill"))
        let statsNav = statsCoordinator.navigationController
        statsNav.tabBarItem = UITabBarItem(title: "Stats",
                                           image: UIImage(systemName: "chart.bar"),
                                           selectedImage: UIImage(systemName: "chart.bar"))
        
        tabBarController.viewControllers = [
            tasksNav,
            statsNav
        ]
        
        addChildCoordinator(tasksCoordinator)
        addChildCoordinator(statsCoordinator)
    }
    
    func getRootViewController() -> UITabBarController {
        return tabBarController
    }
}
