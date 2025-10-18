//
//  TaskViewModel.swift
//  Fill In
//
//  Created by Дмитрий on 16.10.2025.
//

import Foundation

final class TaskViewModel {
    private let getTasksUseCase: GetTasksUseCase
    private let deleteTaskUseCase: DeleteTaskUseCase
    
    private(set) var tasks: [Task] = [] { //Нужен ли?
        didSet { onTasksUpdated?(tasks) }
    }
    
    var onTasksUpdated: (([Task]) -> Void)?
    var onAddTaskTapped: (() -> Void)? //Нужен ли?
    
    init(getTasksUseCase: GetTasksUseCase,
         deleteTaskUseCase: DeleteTaskUseCase) {
        self.getTasksUseCase = getTasksUseCase
        self.deleteTaskUseCase = deleteTaskUseCase
    }
    
    func loadTasks() {
        tasks = getTasksUseCase.execute()
    }
    
//    func addNewTask(_ task: Task) {
//        addTaskUseCase.execute(task: task)
//        loadTasks() // Судя по всему нужно этот метод переместить в AddTaskViewModel и связать его с loadTasks
//    }
    
    func deleteTask(_ task: Task) { deleteTaskUseCase.execute(task: task) }
    
    func addTaskButtonTapped() {
        onAddTaskTapped?()
    }
}
