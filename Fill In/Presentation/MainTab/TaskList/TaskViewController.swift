//
//  TaskViewController.swift
//  Fill In
//
//  Created by Дмитрий on 16.10.2025.
//

import UIKit

final class TaskViewController: BaseViewController<TaskView, TaskViewModel> {
    
    private var tasks: [Task] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Task"
        
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self // Создать методы во view
        mainView.tableView.register(TaskCell.self, forCellReuseIdentifier: "TaskCell")
        
        mainView.addButtonAction = { [weak self] in
            self?.viewModel.addTaskButtonTapped()
        }
    }
}

extension TaskViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as? TaskCell else {
            return UITableViewCell()
        }
        let task = tasks[indexPath.row]
        cell.configure(with: task)
        return cell
    }
}
