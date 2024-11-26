//
//  ListInteractorInput.swift
//  ToDoList
//
//  Created by Albert Garipov on 19.11.2024.
//

import Foundation

protocol ListInteractorInput: AnyObject {
    var outPut: ListInteractorOutput? { get set }

    func loadInitialData()
    func deleteItem(at index: Int, from items: [NoteItem])
    func fetchData() -> [NoteItem]
    func updateCheckmark(for item: NoteItem, isCompleted: Bool)
}
