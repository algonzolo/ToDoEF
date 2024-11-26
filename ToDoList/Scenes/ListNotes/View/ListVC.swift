//
//  ListVC.swift
//  ToDoList
//
//  Created by Albert Garipov on 19.11.2024.
//

import UIKit

final class ListVC: UIViewController {
    
    //MARK: - Private properties -
    let searchController = UISearchController()
    let contenView = ListNotesView()
    var output: ListViewOutput?
    
    var todoItems: [NoteItem] = []
    var filteredTodoItems: [NoteItem] = []
    var isSearchActive: Bool {
        return searchController.isActive && !(searchController.searchBar.text?.isEmpty ?? true)
    }
    
    override func loadView() {
        super.loadView()
        view = contenView
        contenView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegateAndDataSourceTableView()
        output?.onViewDidLoad()
        setupNavigation()
        setupSearchController()
        if todoItems.isEmpty {
            contenView.showLoadingIndicator()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

//MARK: - Public -

extension ListVC {
    func setOutput(output: ListViewOutput) {
        self.output = output
    }
}

//MARK: - ListViewInput -
extension ListVC: ListViewInput {
    func updateView(with data: [NoteItem]) {
        contenView.hideLoadingIndicator()
        self.todoItems = data
        self.filteredTodoItems = data
        contenView.updateCounterLabel(with: todoItems.count)
        contenView.tableView.reloadData()
    }
    
    func showLoading() {
        contenView.showLoadingIndicator()
    }

    func hideLoading() {
        contenView.hideLoadingIndicator()
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource -
extension ListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearchActive ? filteredTodoItems.count : todoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListNotesCell.identifier, for: indexPath) as? ListNotesCell else {
            return UITableViewCell()
        }
        
        let item = isSearchActive ? filteredTodoItems[indexPath.row] : todoItems[indexPath.row]
        cell.configure(data: item, indexPath: indexPath)
        cell.delegate = self
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.layoutIfNeeded()
        
        let selectedNote = isSearchActive ? filteredTodoItems[indexPath.row] : todoItems[indexPath.row]
        output?.didSelectNote(selectedNote)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            showLoading()
            output?.deleteItem(at: indexPath.row, from: todoItems)
            updateFilteredItems()
            hideLoading()
        }
    }
}

//MARK: - Private -

private extension ListVC {
    func setDelegateAndDataSourceTableView() {
        contenView.setupDelegateAndDataSource(delegate: self, dataSource: self)
    }
    
    func setupNavigation() {
        navigationItem.title = "Задачи"
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.searchController = searchController
    }
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func updateFilteredItems() {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            filteredTodoItems = todoItems
            return
        }
        
        filteredTodoItems = todoItems.filter { note in
            guard let title = note.title?.lowercased(), let details = note.details?.lowercased() else {
                return false
            }
            
            return title.contains(searchText.lowercased()) || details.contains(searchText.lowercased())
        }
        
        contenView.tableView.reloadData()
    }
}

// MARK: - UISearchResultsUpdating
extension ListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        updateFilteredItems()
        contenView.tableView.reloadData()
    }
}

extension ListVC: ListNotesViewDelegate {
    func didTapFooterButton() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.layoutIfNeeded()
        output?.didTapCreateButton()
    }
}

extension ListVC: ListNotesCellDelegate {
    func didToggleCheckmark(for indexPath: IndexPath, isCompleted: Bool) {
        todoItems[indexPath.row].isCompleted = isCompleted
        contenView.tableView.reloadRows(at: [indexPath], with: .none)
        output?.updateCheckmark(for: todoItems[indexPath.row], isCompleted: isCompleted)
    }
}
