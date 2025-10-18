//
//  TaskViewController.swift
//  Fill In
//
//  Created by Дмитрий on 16.10.2025.
//

import UIKit

final class TaskViewController: BaseViewController<TaskView, TaskViewModel> {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Task"
        
        mainView.addButtonAction = { [weak self] in
            self?.viewModel.addTaskButtonTapped()
        }
    }
}
