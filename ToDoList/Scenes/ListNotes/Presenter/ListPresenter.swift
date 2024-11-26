//
//  ListPresenter.swift
//  ToDoList
//
//  Created by Albert Garipov on 19.11.2024.
//

import Foundation

final class ListPresenter {
    //MARK: - Private properties -
    weak var view: ListViewInput?
    private let interactor: ListInteractorInput
    private let router: ListRouterInput
    
    init(view: ListViewInput,
         interactor: ListInteractorInput,
         router:ListRouterInput) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

//MARK: - ListViewOutput -
extension ListPresenter: ListViewOutput {
    func updateCheckmark(for note: NoteItem, isCompleted: Bool) {
        interactor.updateCheckmark(for: note, isCompleted: isCompleted)
    }
    
    func didSelectNote(_ note: NoteItem) {
        router.openDetailScreen(note: note, mode: .edit)
    }
    
    func didTapCreateButton() {
        router.openDetailScreen(note: nil, mode: .create)
    }
    
    func deleteItem(at index: Int, from items: [NoteItem]) {
        interactor.deleteItem(at: index, from: items)
    }
    
    func onViewDidLoad() {
        interactor.loadInitialData()
    }
    
    func reloadData() {
        let updatedData = interactor.fetchData()
        view?.updateView(with: updatedData)
    }
}

//MARK: - ListInteractorOutput -
extension ListPresenter: ListInteractorOutput {
    func didUpdateItem(_ item: NoteItem) {
        let updatedData = interactor.fetchData()
        view?.updateView(with: updatedData)
    }
    
    func didLoadData(_ data: [NoteItem]) {
        view?.updateView(with: data)
    }
}
