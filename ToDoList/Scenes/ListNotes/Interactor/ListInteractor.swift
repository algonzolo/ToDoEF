//
//  ListInteractor.swift
//  ToDoList
//
//  Created by Albert Garipov on 19.11.2024.
//

import Foundation
import CoreData

final class ListInteractor: ListInteractorInput {
    weak var outPut: ListInteractorOutput?
    private let networkManager = APIClient()
    private var todoItems: [NoteItem] = []
    private var isDataLoaded = false

    private func fetchLocalData() -> [NoteItem] {
        CoreDataManager.shared.fetchTodoItems(sortedByCreatedAt: false)
    }

    func loadInitialData() {
        guard !isDataLoaded else { return }
        isDataLoaded = true

        todoItems = fetchLocalData()
        outPut?.didLoadData(todoItems)

        if todoItems.isEmpty {
            DataManager().loadInitialData { [weak self] in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.todoItems = self.fetchLocalData()
                    self.outPut?.didLoadData(self.todoItems)
                }
            }
        }
    }

    func deleteItem(at index: Int, from items: [NoteItem]) {
        let itemToDelete = items[index]
        CoreDataManager.shared.deleteTodoItem(item: itemToDelete)
        todoItems = fetchLocalData()
        outPut?.didLoadData(todoItems)
    }
    
    func fetchData() -> [NoteItem] {
        return fetchLocalData()
    }
    
    func updateCheckmark(for item: NoteItem, isCompleted: Bool) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        context.perform {
            item.isCompleted = isCompleted
            do {
                try context.save()
                DispatchQueue.main.async {
                    self.outPut?.didUpdateItem(item)
                }
            } catch {
                print("Failed to update checkmark: \(error)")
            }
        }
    }
}
