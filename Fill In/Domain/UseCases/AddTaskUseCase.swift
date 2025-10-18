//
//  AddTaskUseCase.swift
//  Fill In
//
//  Created by Дмитрий on 17.10.2025.
//

import Foundation

final class AddTaskUseCase {
    
    private let repository: TaskRepository
    
    init(repository: TaskRepository) {
        self.repository = repository
    }
    
    func execute(task: Task) {
        repository.addTask(task)
    }
}
