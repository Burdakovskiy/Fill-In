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
        title = "Tasks"
        
        mainView.set(delegate: self)
        mainView.set(dataSourse: self)
        
        bindViewModel()
        mainView.addButtonAction = { [weak self] in
            self?.viewModel.addTaskButtonTapped()
        }
        mainView.onCategorySelected = { [weak self] category in
            self?.viewModel.applyFilter(for: category)
        }
        viewModel.loadTasks()
        
        if let firstCategory = FilterTaskCategory.allCases.first {
            viewModel.applyFilter(for: firstCategory)
        }
    }
    
    private func bindViewModel() {
        viewModel.onTasksUpdated = { [weak self] tasks in
            self?.tasks = tasks
            self?.mainView.reloadTableViewData()
        }
        
        viewModel.onFiltersUpdated = { [weak self] filtersWithCounts in
            self?.mainView.updateCategories(filtersWithCounts)
        }
    }
}

extension TaskViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskCell.id, for: indexPath) as? TaskCell else {
            return UITableViewCell()
        }
        let task = tasks[indexPath.row]
        cell.configure(with: task)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = tasks[indexPath.row]
        viewModel.selected(task: task)
        tableView.deselectRow(at: indexPath, animated: true)
//        mainView.deselectRow(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completion in
            guard let self = self else { return }
            let alert = UIAlertController(title: "Delete task?",
                                          message: "This action cannot be undone.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
                let task = self.tasks[indexPath.row]
                self.viewModel.deleteTask(task)
            })
            self.present(alert, animated: true)
            
            completion(true)
        }
        
        deleteAction.backgroundColor = .systemRed
        deleteAction.image = UIImage(systemName: "trash")
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        config.performsFirstActionWithFullSwipe = true
        return config
    }
}
