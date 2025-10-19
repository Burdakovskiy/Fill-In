//
//  AddTaskViewController.swift
//  Fill In
//
//  Created by Дмитрий on 16.10.2025.
//

import UIKit

final class AddTaskViewController: BaseViewController<AddTaskView, AddTaskViewModel> {
    
    private var task: Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.isEditing ? "Edit Task" : "Add Task"
        view.backgroundColor = .white
        setupUI()
        
        if let task = viewModel.task {
            print("📦 Отображаем таску: \(task.title)")
            self.task = task
        }
    }
    
    private func setupUI() {
        let saveButton = UIButton(type: .system)
        saveButton.setTitle("Save Mock Task", for: .normal)
        saveButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        saveButton.backgroundColor = .black
        saveButton.tintColor = .white
        saveButton.layer.cornerRadius = 10
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 180),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
    }
    
    @objc private func saveTapped() {
        // Создаём моковую задачу (без реального сохранения)
        let mockTask = Task(
            id: UUID().uuidString,
            title: "Mock Task \(Int.random(in: 1...100))",
            description: "This is a mock task",
            isCompleted: false,
            category: .other,
            date: Date(),
            importance: .medium
        )
        print("✅ Mock task created:", mockTask.title)
        viewModel.mockSave(task: mockTask)
    }
}
