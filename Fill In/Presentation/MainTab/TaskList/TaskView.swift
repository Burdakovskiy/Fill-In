//
//  TaskView.swift
//  Fill In
//
//  Created by Дмитрий on 16.10.2025.
//

import UIKit

final class TaskView: UIView {
    
    var addButtonAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addTaskButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        addSubview(addTaskButton)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let addTaskButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 28, weight: .bold)
        let plusImage = UIImage(systemName: "plus", withConfiguration: config)
        button.setImage(plusImage, for: .normal)
        button.tintColor = .white
        button.backgroundColor = .black
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowOpacity = 0.25
        button.layer.shadowRadius = 5
        return button
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addTaskButton.layer.cornerRadius = addTaskButton.frame.height / 2
    }
    
    @objc private func addButtonTapped() {
        addButtonAction?()
    }
}

private extension TaskView {
    func setConstraints() {
        NSLayoutConstraint.activate([
            addTaskButton.widthAnchor.constraint(equalToConstant: 60),
            addTaskButton.heightAnchor.constraint(equalToConstant: 60),
            addTaskButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            addTaskButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ])
    }
}
