//
//  UserSettingsRepository.swift
//  Fill In
//
//  Created by Дмитрий on 19.10.2025.
//

import Foundation

protocol UserSettingsRepository {
    func getActiveFilters() -> [FilterTaskCategory]
    func setActiveFilters(_ filters: [FilterTaskCategory])
}
