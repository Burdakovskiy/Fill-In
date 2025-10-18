//
//  TaskRepository.swift
//  Fill In
//
//  Created by Дмитрий on 17.10.2025.
//

import Foundation

protocol TaskRepository {
    func getAllTasks() -> [Task]
    func addTask(_ task: Task)
    func updateTask(_ task: Task)
    func deleteTask(_ task: Task)
}
