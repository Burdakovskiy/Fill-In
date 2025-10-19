//
//  TaskView.swift
//  Fill In
//
//  Created by Дмитрий on 16.10.2025.
//

import UIKit

final class TaskView: UIView {
    
    //MARK: - Callbacks
    var addButtonAction: (() -> Void)?
    var onCategorySelected: ((FilterTaskCategory) -> Void)?
    
    //MARK: - State
    private var selectedCategory: FilterTaskCategory?
    private var categories: [FilterCategoryViewModel] = []
    
    //MARK: - UI Elements
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.register(TaskCell.self, forCellReuseIdentifier: TaskCell.id)
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
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
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupCollectionView()
        setConstraints()
        addTaskButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addTaskButton.layer.cornerRadius = addTaskButton.frame.height / 2
    }
    
    //MARK: - Setup
    private func setupCollectionView() {
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.id)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setupUI() {
        addSubview(collectionView)
        addSubview(tableView)
        addSubview(addTaskButton)
    }
    
    //MARK: - Actions
    @objc private func addButtonTapped() {
        addButtonAction?()
    }
    
    //MARK: - Public Methods
    func set(delegate: UITableViewDelegate) {
        tableView.delegate = delegate
    }
    
    func set(dataSourse: UITableViewDataSource) {
        tableView.dataSource = dataSourse
    }
    
    func reloadTableViewData() {
        tableView.reloadData()
    }
    
    func deselectRow(at indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func updateCategories(_ filtersWithCounts: [FilterCategoryViewModel]) {
        self.categories = filtersWithCounts
        
        if selectedCategory == nil, let first = filtersWithCounts.first?.category {
            selectedCategory = first
            onCategorySelected?(first)
        }
        
        collectionView.reloadData()
    }
}


//MARK: - UICollectionView
extension TaskView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.id, for: indexPath) as! CategoryCell
        let model = categories[indexPath.item]
        
        cell.configure(with: model.title)
        cell.setSelectedState(model.category == selectedCategory)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selected = categories[indexPath.item].category
        
        selectedCategory = selected
        collectionView.reloadData()
        
        onCategorySelected?(selected)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let filterModel = categories[indexPath.item]
        let title = filterModel.title
        let width = title.size(withAttributes: [.font: UIFont.systemFont(ofSize: 15, weight: .medium)]).width + 30
        return CGSize(width: width, height: 34)
    }
}


//MARK: - Constraints
private extension TaskView {
    func setConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 45),
            
            tableView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: addTaskButton.topAnchor, constant: -20),
            
            addTaskButton.widthAnchor.constraint(equalToConstant: 60),
            addTaskButton.heightAnchor.constraint(equalToConstant: 60),
            addTaskButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            addTaskButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
}
