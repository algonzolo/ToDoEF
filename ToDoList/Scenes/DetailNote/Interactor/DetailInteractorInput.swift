//
//  DetailInteractorInput.swift
//  ToDoList
//
//  Created by Albert Garipov on 19.11.2024.
//

import Foundation

protocol DetailInteractorInput: AnyObject {
    var output: DetailInteractorOutput? { get set }
    func saveNewNote(title: String, description: String, created: Date)
    func updateExistingNote(_ note: NoteItem)
}
