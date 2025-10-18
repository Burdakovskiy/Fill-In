//
//  TasksCoordinator.swift
//  Fill In
//
//  Created by Дмитрий on 16.10.2025.
//

import UIKit

final class TasksCoordinator: BaseCoordinator {
    private let moduleFactory: TasksModuleFactory
    
    init(moduleFactory: TasksModuleFactory) {
        self.moduleFactory = moduleFactory
    }
    
    override func start() {
        let controller = moduleFactory.makeTasksViewController()
        
        controller.viewModel.onAddTaskTapped = { [weak self] in
            self?.showAddTask()
        }
        
        navigationController.viewControllers = [controller]
        print("Tasks start")
    }
    
    func showAddTask() {
        let addTaskViewModel = AddTaskViewModel()
        let addTaskVC = AddTaskViewController(viewModel: addTaskViewModel)
        navigationController.pushViewController(addTaskVC, animated: true) //Переписать на фабрику
    }
}
