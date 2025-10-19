//
//  TaskMapper.swift
//  Fill In
//
//  Created by Дмитрий on 18.10.2025.
//

import Foundation

struct TaskMapper {
    static func mapToDomain(_ object: RealmTaskObject) -> Task {
        Task(id: object.id,
             title: object.title,
             description: object.description,
             isCompleted: object.isCompleted,
             category: TaskCategory(rawValue: object.categoryRaw) ?? .other,
             date: object.date,
             importance: TaskImportance(rawValue: object.importanceRaw) ?? .medium
        )
    }
    
    static func mapToRealm(_ task: Task) -> RealmTaskObject {
        let object = RealmTaskObject()
        object.id = task.id
        object.title = task.title
        object.taskDescription = task.description
        object.isCompleted = task.isCompleted
        object.categoryRaw = task.category.rawValue
        object.date = task.date
        object.importanceRaw = task.importance.rawValue
        return object
    }
}
