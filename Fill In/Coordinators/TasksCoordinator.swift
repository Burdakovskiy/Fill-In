//
//  TasksCoordinator.swift
//  Fill In
//
//  Created by Дмитрий on 16.10.2025.
//

import UIKit

final class TasksCoordinator: BaseCoordinator {
    
    override func start() {
        let viewModel = TaskViewModel()
        let controller = TaskViewController(viewModel: viewModel)
        
        viewModel.onAddTaskTapped = { [weak self] in
            self?.showAddTask()
        }
        navigationController.viewControllers = [controller]
        print("Tasks start")
    }
    
    func showAddTask() {
        let addTaskViewModel = AddTaskViewModel()
        let addTaskVC = AddTaskViewController(viewModel: addTaskViewModel)
        navigationController.pushViewController(addTaskVC, animated: true)
    }
}
