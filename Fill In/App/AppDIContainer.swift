//
//  AppDIContainer.swift
//  Fill In
//
//  Created by Дмитрий on 17.10.2025.
//

import Foundation

final class AppDIContainer {
    
    //MARK: - Services
    lazy var speechService: SpeechService = SpeechService()
    
    //MARK: - Data
    lazy var taskRepository: TaskRepository = MockTaskRepository() //MockTaskRepository //RealmTaskRepository
    lazy var settingsRepository: UserSettingsRepository = UserDefaultsUserSettingsRepository()
    
    //MARK: - UseCases
    
    func makeAddTaskUseCase() -> AddTaskUseCase { AddTaskUseCase(repository: taskRepository) }
    func makeGetTasksUseCase() -> GetTasksUseCase { GetTasksUseCase(repository: taskRepository) }
    func makeUpdateTaskUseCase() -> UpdateTaskUseCase { UpdateTaskUseCase(repository: taskRepository) }
    func makeDeleteTaskUseCase() -> DeleteTaskUseCase { DeleteTaskUseCase(repository: taskRepository)}
    func makeGetActiveFiltersUseCase() -> GetActiveFiltersUseCase { GetActiveFiltersUseCase(settingsRepository: settingsRepository)}
    func makeUpdateActiveFiltersUseCase() -> UpdateActiveFiltersUseCase { UpdateActiveFiltersUseCase(settingRepository: settingsRepository)}
}
