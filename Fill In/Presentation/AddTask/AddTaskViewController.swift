//
//  AddTaskViewController.swift
//  Fill In
//
//  Created by Дмитрий on 16.10.2025.
//

import UIKit

final class AddTaskViewController: BaseViewController<AddTaskView, AddTaskViewModel> {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Task"
        view.backgroundColor = .white
    }
}
