//
//  BaseViewController.swift
//  Fill In
//
//  Created by Дмитрий on 16.10.2025.
//

import UIKit

class BaseViewController<RootView: UIView, ViewModelType>: UIViewController {
    
    var mainView: RootView { view as! RootView }
    var viewModel: ViewModelType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        view = RootView()
    }
}
