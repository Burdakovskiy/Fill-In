//
//  Task.swift
//  Fill In
//
//  Created by Дмитрий on 17.10.2025.
//

import Foundation

struct Task {
    let id: String
    var title: String
    var description: String
    var isCompleted: Bool
    var category: TaskCategory
    var date: Date
    var importance: TaskImportance
}
