//
//  MockTaskRepository.swift
//  Fill In
//
//  Created by Дмитрий on 18.10.2025.
//

import Foundation

final class MockTaskRepository: TaskRepository {
    
    private var storage: [Task] = []
    
    init() {
            print("🧱 MockTaskRepository initialized at \(Unmanaged.passUnretained(self).toOpaque())")
        }
    
    func getAllTasks() -> [Task] {
        print("📦 возвращено \(storage.count) задач из \(Unmanaged.passUnretained(self).toOpaque())")
        return storage
    }
    
    func addTask(_ task: Task) {
        storage.append(task)
        print("🟢 добавлена \(task.title) в \(Unmanaged.passUnretained(self).toOpaque())")
    }
    
    func updateTask(_ task: Task) {
        guard let index = storage.firstIndex(where: { $0.id == task.id }) else { return }
        storage[index] = task
    }
    
    func deleteTask(_ task: Task) {
        storage.removeAll { $0.id == task.id }
    }
}
