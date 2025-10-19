//
//  TasksModuleFactory.swift
//  Fill In
//
//  Created by Дмитрий on 18.10.2025.
//

import Foundation

final class TasksModuleFactory {
    private let diContainer: AppDIContainer
    
    init(diContainer: AppDIContainer) {
        self.diContainer = diContainer
    }
    
    func makeTasksViewController() -> TaskViewController {
        let viewModel = TaskViewModel(getTasksUseCase: diContainer.makeGetTasksUseCase(),
                                      deleteTaskUseCase: diContainer.makeDeleteTaskUseCase(),
                                      getActiveFiltersUseCase: diContainer.makeGetActiveFiltersUseCase())
        return TaskViewController(viewModel: viewModel)
    }
    
    func makeAddTaskViewController(task: Task?) -> AddTaskViewController {
        let viewModel = AddTaskViewModel(addTaskUseCase: diContainer.makeAddTaskUseCase(),
                                         updateTaskUseCase: diContainer.makeUpdateTaskUseCase(),
                                         deleteTaskUseCase: diContainer.makeDeleteTaskUseCase(),
                                         task: task)
        return AddTaskViewController(viewModel: viewModel)
    }
}
