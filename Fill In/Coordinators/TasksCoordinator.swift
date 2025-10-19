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
        super.init()
    }
    
    override func start() {
        let controller = moduleFactory.makeTasksViewController()
        
        controller.viewModel.onAddTaskTapped = { [weak self] in
            self?.showAddTask()
        }
        
        controller.viewModel.onTaskSelected = { [weak self] task in
            self?.showEditTask(task)
        }
        
        navigationController.viewControllers = [controller]
    }
    
    private func showAddTask() {
        let addVC = moduleFactory.makeAddTaskViewController(task: nil)
        addVC.viewModel.onTaskSaved = { [weak self] in
            self?.reloadTaskAndClose()
        }
        navigationController.pushViewController(addVC, animated: true)
    }
        
    private func showEditTask(_ task: Task) {
        let editVC = moduleFactory.makeAddTaskViewController(task: task)
        navigationController.pushViewController(editVC, animated: true)
    }
    
    private func reloadTaskAndClose() {
        if let tasksVC = navigationController.viewControllers.first as? TaskViewController {
            tasksVC.viewModel.loadTasks()
        }
        navigationController.popViewController(animated: true)
    }
}
