//
//  AddTaskViewModel.swift
//  Fill In
//
//  Created by Дмитрий on 16.10.2025.
//

import Foundation

final class AddTaskViewModel {
    
    //MARK: - Dependencies
    private let addTaskUseCase: AddTaskUseCase
    private let updateTaskUseCase: UpdateTaskUseCase
    private let deleteTaskUseCase: DeleteTaskUseCase
    
    //MARK: - State
    private(set) var isEditing: Bool
    private(set) var task: Task?
    
    //MARK: - Callbacks
    var onTaskSaved: (() -> Void)?
    var onError: ((String) -> Void)?
    
    //MARK: - Init
    init(addTaskUseCase: AddTaskUseCase,
         updateTaskUseCase: UpdateTaskUseCase,
         deleteTaskUseCase: DeleteTaskUseCase,
         task: Task? = nil) {
        self.addTaskUseCase = addTaskUseCase
        self.updateTaskUseCase = updateTaskUseCase
        self.deleteTaskUseCase = deleteTaskUseCase
        self.task = task
        self.isEditing = (task != nil)
        if let task = task {
            print("🟢 Переход по таске: \(task.title), id: \(task.id)")
        } else {
            print("🆕 Создание новой таски")
        }
    }
    
    //MARK: - Public Methods
    func saveTask(title: String, description: String, category: TaskCategory, date: Date, importance: TaskImportance) {
        guard !title.isEmpty else {
            onError?("Title cannot be empty")
            return
        }
        
        if isEditing {
            updateExistingTask(title: title, description: description, category: category, date: date, importance: importance)
        } else {
            createNewTask(title: title, description: description, category: category, date: date, importance: importance)
        }
    }
    
    //MARK: - Prifate Methods
    private func createNewTask(title: String, description: String, category: TaskCategory, date: Date, importance: TaskImportance) {
        let newTask = Task(id: UUID().uuidString,
                           title: title,
                           description: description,
                           isCompleted: false,
                           category: category,
                           date: date,
                           importance: importance)
        addTaskUseCase.execute(task: newTask)
        onTaskSaved?()
    }
    
    private func updateExistingTask(title: String, description: String, category: TaskCategory, date: Date, importance: TaskImportance) {
        guard var task = task else {
            print("AddTaskViewModel.updateExistingTask there is no task to update")
            return
        }
        task.title = title
        task.description = description
        task.category = category
        task.date = date
        task.importance = importance
        
        updateTaskUseCase.execute(task: task)
        onTaskSaved?()
    }
    
    func mockSave(task: Task) {
        print("💾 Mock save called: \(task.title)")
        addTaskUseCase.execute(task: task)
        onTaskSaved?()
    }
}
