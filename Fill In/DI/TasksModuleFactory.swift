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
                                      addTaskUseCase: diContainer.makeAddTaskUseCase(),
                                      updateTaskUseCase: diContainer.makeUpdateTaskUseCase(),
                                      deleteTaskUseCase: diContainer.makeDeleteTaskUseCase())
        return TaskViewController(viewModel: viewModel)
    }
}
