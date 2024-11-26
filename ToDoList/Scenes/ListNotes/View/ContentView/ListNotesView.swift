//
//  ListNotesView.swift
//  ToDoList
//
//  Created by Albert Garipov on 19.11.2024.
//

import UIKit

fileprivate enum Constants {
    static let leftOffset: CGFloat = 10
    static let rightOffset: CGFloat = 16
    static let tableViewTopOffset: CGFloat = 15
    static let footerHeight: CGFloat = 80
}

protocol ListNotesViewDelegate: AnyObject {
    func didTapFooterButton()
}

final class ListNotesView: UIView {
    // MARK: - Private properties -
    let tableView = UITableView()
    private let toolbar = UIToolbar()
    private let counterLabel = UILabel()
    private let createButton = UIButton(type: .system)
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    weak var delegate: ListNotesViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public -
extension ListNotesView {
    func setupDelegateAndDataSource(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
        tableView.delegate = delegate
        tableView.dataSource = dataSource
    }
    
    func updateCounterLabel(with count: Int) {
        counterLabel.text = "Заметок: \(count)"
    }
}

// MARK: - UI -
private extension ListNotesView {
    func setupUI() {
        addSubview(tableView)
        addSubview(toolbar)
        addSubview(createButton)
        addSubview(activityIndicator)
        toolbar.addSubview(counterLabel)
        setupTableView()
        setupConstraints()
        settingView()
        setupToolbar()
    }
    
    func setupTableView() {
        tableView.register(ListNotesCell.self, forCellReuseIdentifier: ListNotesCell.identifier)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
    }
    
    func setupToolbar() {
        counterLabel.font = UIFont.systemFont(ofSize: 14)
        counterLabel.textColor = .secondaryLabel
        counterLabel.textAlignment = .center
        
        createButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        createButton.tintColor = .systemYellow
        createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
    }
    
    
    func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        counterLabel.translatesAutoresizingMaskIntoConstraints = false
        createButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constants.tableViewTopOffset),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: toolbar.topAnchor),
            
            toolbar.leadingAnchor.constraint(equalTo: leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: trailingAnchor),
            toolbar.bottomAnchor.constraint(equalTo: bottomAnchor),
            toolbar.heightAnchor.constraint(equalToConstant: Constants.footerHeight),
            
            counterLabel.centerXAnchor.constraint(equalTo: toolbar.centerXAnchor),
            counterLabel.centerYAnchor.constraint(equalTo: toolbar.centerYAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            createButton.centerYAnchor.constraint(equalTo: toolbar.centerYAnchor),
            createButton.trailingAnchor.constraint(equalTo: toolbar.trailingAnchor, constant: -20)
        ])
    }
    
    func settingView() {
        backgroundColor = .systemBackground
        activityIndicator.hidesWhenStopped = true
    }
    
    @objc private func createButtonTapped() {
        delegate?.didTapFooterButton()
    }
}

extension ListNotesView {
    func showLoadingIndicator() {
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
    }
}
