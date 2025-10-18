//
//  RealmTaskRepository.swift
//  Fill In
//
//  Created by Дмитрий on 18.10.2025.
//

import RealmSwift

final class RealmTaskRepository: TaskRepository {
    private let realm: Realm
    
    init() {
        do {
            realm = try Realm()
        } catch {
            fatalError("Realm init failed: \(error.localizedDescription)")
        }
    }
    
    func getAllTasks() -> [Task] {
        let objects = realm.objects(RealmTaskObject.self)
        return objects.map(TaskMapper.mapToDomain)
    }
    
    func addTask(_ task: Task) {
        let object = TaskMapper.mapToRealm(task)
        try? realm.write {
            realm.add(object, update: .modified)
        }
    }
    
    func updateTask(_ task: Task) {
        try? realm.write {
            if let existing = realm.object(ofType: RealmTaskObject.self, forPrimaryKey: task.id) {
                existing.title = task.title
                existing.taskDescription = task.description
                existing.isCompleted = task.isCompleted
                existing.categoryRaw = task.category.rawValue
                existing.date = task.date
                existing.importanceRaw = task.importance.rawValue
            } else {
                fatalError("Can't find existing task object by id: \(task.id)")
            }
        }
    }
    
    func deleteTask(_ task: Task) {
        guard let object = realm.object(ofType: RealmTaskObject.self, forPrimaryKey: task.id) else {
            fatalError("Can't find existing task object by id: \(task.id)")
        }
        try? realm.write {
            realm.delete(object)
        }
    }
}
