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
    
    init(getTasksUseCase: GetTasksUseCase,
         addTaskUseCase: AddTaskUseCase,
         updateTaskUseCase: UpdateTaskUseCase,
         deleteTaskUseCase: DeleteTaskUseCase) {
        self.getTasksUseCase = getTasksUseCase
        self.addTaskUseCase = addTaskUseCase
        self.updateTaskUseCase = updateTaskUseCase
        self.deleteTaskUseCase = deleteTaskUseCase
    }
    
    func loadTasks() -> [Task] { getTasksUseCase.execute() }
    func addNewTask(_ task: Task) { addTaskUseCase.execute(task: task) }
    func updateTask(_ task: Task) { updateTaskUseCase.execute(task: task) }
    func deleteTask(_ task: Task) { deleteTaskUseCase.execute(task: task) }
    
    var onAddTaskTapped: (() -> Void)?
    
    func addTaskButtonTapped() {
        onAddTaskTapped?()
    }
}
