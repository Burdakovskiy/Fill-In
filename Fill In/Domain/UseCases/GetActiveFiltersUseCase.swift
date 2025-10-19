//
//  GetActiveFiltersUseCase.swift
//  Fill In
//
//  Created by Дмитрий on 19.10.2025.
//

import Foundation

final class GetActiveFiltersUseCase {
    private let settingsRepository: UserSettingsRepository
    
    init(settingsRepository: UserSettingsRepository) {
        self.settingsRepository = settingsRepository
    }
    
    func execute() -> [FilterTaskCategory] {
        settingsRepository.getActiveFilters()
    }
}
