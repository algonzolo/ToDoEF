//
//  DetailInteractor.swift
//  ToDoList
//
//  Created by Albert Garipov on 19.11.2024.
//

import Foundation

final class DetailInteractor {
    weak var output: DetailInteractorOutput?
}

//MARK: - Public -
extension DetailInteractor {
    func setOutput(output: DetailInteractorOutput) {
        self.output = output
    }
}

//MARK: - DetailInteractorInput -
extension DetailInteractor: DetailInteractorInput {
    func saveNewNote(title: String, description: String, created: Date) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        context.perform {
            let newNote = NoteItem(context: context)
            newNote.title = title
            newNote.details = description
            newNote.createdAt = created
            newNote.isCompleted = false

            do {
                try context.save()
                self.output?.didSaveNote()
            } catch {
                print("Failed to save new note: \(error)")
            }
        }
    }
    
    func updateExistingNote(_ note: NoteItem) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        context.perform {
            if context.hasChanges {
                do {
                    try context.save()
                    DispatchQueue.main.async {
                        self.output?.didSaveNote()
                    }
                } catch {
                    print("Failed to update note: \(error)")
                }
            } else {
                DispatchQueue.main.async {
                    self.output?.didSaveNote()
                }
            }
        }
    }
}
