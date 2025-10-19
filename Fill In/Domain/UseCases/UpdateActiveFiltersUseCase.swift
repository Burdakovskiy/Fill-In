//
//  UpdateActiveFiltersUseCase.swift
//  Fill In
//
//  Created by Дмитрий on 19.10.2025.
//

import Foundation

final class UpdateActiveFiltersUseCase {
    private let settingRepository: UserSettingsRepository
    
    init(settingRepository: UserSettingsRepository) {
        self.settingRepository = settingRepository
    }
    
    func execute(_ filters: [FilterTaskCategory]) {
        settingRepository.setActiveFilters(filters)
    }
}
