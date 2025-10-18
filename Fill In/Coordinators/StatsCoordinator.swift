//
//  StatsCoordinator.swift
//  Fill In
//
//  Created by Дмитрий on 16.10.2025.
//

import UIKit

final class StatsCoordinator: BaseCoordinator {
    
    override func start() {
        let statsViewModel = StatsViewModel()
        let controller = StatsViewController(viewModel: statsViewModel)
        
        navigationController.viewControllers = [controller]
        print("Stats start")
    }
}
