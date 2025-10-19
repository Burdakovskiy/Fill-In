//
//  FilterCategoryViewModel.swift
//  Fill In
//
//  Created by Дмитрий on 19.10.2025.
//

import Foundation

struct FilterCategoryViewModel {
    let category: FilterTaskCategory
    let count: Int
    
    var title: String { "\(category.rawValue) (\(count))" }
}
