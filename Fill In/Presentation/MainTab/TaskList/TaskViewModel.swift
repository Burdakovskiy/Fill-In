//
//  TaskViewModel.swift
//  Fill In
//
//  Created by Дмитрий on 16.10.2025.
//

import Foundation

final class TaskViewModel {
    private let getTasksUseCase: GetTasksUseCase
    private let addTaskUseCase: AddTaskUseCase
    private let updateTaskUseCase: UpdateTaskUseCase
    private let deleteTaskUseCase: DeleteTaskUseCase
    
    var onAddTaskTapped: (() -> Void)?
    
    func addTaskButtonTapped() {
        onAddTaskTapped?()
    }
}
