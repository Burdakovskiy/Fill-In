//
//  MainTabBarController.swift
//  Fill In
//
//  Created by Дмитрий on 16.10.2025.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
    }
    
    private func setupAppearance() {
        tabBar.tintColor = .black
        tabBar.unselectedItemTintColor = .gray
        tabBar.backgroundColor = .systemBackground
        tabBar.isTranslucent = false
        
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.1
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -2)
        tabBar.layer.shadowRadius = 6
    }
}
