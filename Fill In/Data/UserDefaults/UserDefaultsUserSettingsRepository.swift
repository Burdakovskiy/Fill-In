//
//  UserDefaultsUserSettingsRepository.swift
//  Fill In
//
//  Created by Дмитрий on 19.10.2025.
//

import Foundation

final class UserDefaultsUserSettingsRepository: UserSettingsRepository {
    private let key = "active_filters"
    
    func getActiveFilters() -> [FilterTaskCategory] {
        if let data = UserDefaults.standard.array(forKey: key) as? [String] {
            let filters =  data.compactMap { FilterTaskCategory(rawValue: $0) }
            print("⚙️ Загружены фильтры из UserDefaults: \(filters)")
            return filters
        }
        print("⚙️ Возвращаю все фильтры по умолчанию")
        return  FilterTaskCategory.allCases
    }
    
    func setActiveFilters(_ filters: [FilterTaskCategory]) {
        let data = filters.map { $0.rawValue }
        UserDefaults.standard.set(data, forKey: key)
    }
}
