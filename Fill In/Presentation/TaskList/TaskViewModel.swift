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
    private let getActiveFiltersUseCase: GetActiveFiltersUseCase
    
    private(set) var allTasks: [Task] = [] {
        didSet {
            applyFilter()
        }
    }
    private(set) var filteredTasks: [Task] = [] {
        didSet {
            onTasksUpdated?(filteredTasks)
        }
    }
    private(set) var activeFilters: [FilterTaskCategory] = [] {
        didSet {
            onFiltersUpdated?(activeFiltersWithCounts())
        }
    }
    
    var onTasksUpdated: (([Task]) -> Void)?
    var onAddTaskTapped: (() -> Void)?
    var onTaskSelected: ((Task) -> Void)?
    var onFiltersUpdated: (([FilterCategoryViewModel]) -> Void)?
    
    init(getTasksUseCase: GetTasksUseCase,
         deleteTaskUseCase: DeleteTaskUseCase,
         getActiveFiltersUseCase: GetActiveFiltersUseCase) {
        self.getTasksUseCase = getTasksUseCase
        self.deleteTaskUseCase = deleteTaskUseCase
        self.getActiveFiltersUseCase = getActiveFiltersUseCase
    }
    
    func loadTasks() {
        allTasks = getTasksUseCase.execute()
        activeFilters = getActiveFiltersUseCase.execute()
        applyFilter()
        
        print("📊 Активные фильтры: \(activeFilters.map { $0.rawValue })")
        onFiltersUpdated?(activeFiltersWithCounts())
        onTasksUpdated?(filteredTasks)
        print("📲 ViewModel получила \(allTasks.count) задач")
    }
    
    
    func deleteTask(_ task: Task) {
        deleteTaskUseCase.execute(task: task)
        allTasks.removeAll { $0.id == task.id }
        applyFilter()
        
        onFiltersUpdated?(activeFiltersWithCounts())
    }
    
    func addTaskButtonTapped() {
        onAddTaskTapped?()
    }
    
    func selected(task: Task) {
        onTaskSelected?(task)
    }
    
    func applyFilter(for selected: FilterTaskCategory? = nil) {
        guard let selected = selected else {
            filteredTasks = allTasks
            return
        }
        filteredTasks = filterTasks(for: selected)
        
        onTasksUpdated?(filteredTasks)
        onFiltersUpdated?(activeFiltersWithCounts())
    }
    
    private func activeFiltersWithCounts() -> [FilterCategoryViewModel] {
        return activeFilters.map { category in
            let count = filterTasks(for: category).count
            return FilterCategoryViewModel(category: category, count: count)
        }
    }
    
    private func filterTasks(for category: FilterTaskCategory) -> [Task] {
        switch category {
        case .all:
            allTasks
        case .resently:
            allTasks.filter { Calendar.current.isDateInToday($0.date) }
        case .low:
            allTasks.filter { $0.importance == .low }
        case .medium:
            allTasks.filter { $0.importance == .medium }
        case .high:
            allTasks.filter { $0.importance == .high }
        case .absolute:
            allTasks.filter { $0.importance == .absolute }
        }
    }
}
