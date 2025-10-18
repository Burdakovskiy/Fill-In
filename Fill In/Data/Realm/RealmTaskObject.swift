//
//  RealmTaskObject.swift
//  Fill In
//
//  Created by Дмитрий on 18.10.2025.
//

import RealmSwift
import Foundation

final class RealmTaskObject: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var title: String = ""
    @Persisted var taskDescription: String = ""
    @Persisted var isCompleted: Bool = false
    @Persisted var categoryRaw: String = TaskCategory.other.rawValue
    @Persisted var date: Date = Date()
    @Persisted var importanceRaw: String = TaskImportance.medium.rawValue
}
