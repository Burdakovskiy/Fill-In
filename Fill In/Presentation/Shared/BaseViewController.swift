//
//  BaseViewController.swift
//  Fill In
//
//  Created by Дмитрий on 16.10.2025.
//

import UIKit

class BaseViewController<RootView: UIView, ViewModelType>: UIViewController {
    
    let mainView: RootView
    let viewModel: ViewModelType
    
    init(viewModel: ViewModelType) {
        self.mainView = RootView()
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
}
