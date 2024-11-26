//
//  DetailPresenter.swift
//  ToDoList
//
//  Created by Albert Garipov on 19.11.2024.
//

import UIKit

final class DetailPresenter {
    //MARK: - Private properties -
    weak var view: DetailViewInput?
    private let interactor: DetailInteractorInput
    private let router: DetailRouterInput
    private let mode: DetailScreenMode
    private var note: NoteItem?
    
    init(view: DetailViewInput,
         interactor: DetailInteractorInput,
         router: DetailRouterInput,
         note: NoteItem?,
         mode: DetailScreenMode) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.note = note
        self.mode = mode
    }
}

//MARK: - DetailViewOutput -
extension DetailPresenter: DetailViewOutput {
    
    func onViewDidLoad() {
        view?.display(note: note)
    }
    
    func saveNote(title: String, description: String, created: Date, isEditMode: Bool) {
        if isEditMode {
            guard let note = note else { return }
            
            let hasChanges = note.title != title ||
            note.details != description
            
            if hasChanges {
                note.title = title
                note.details = description
                note.createdAt = created
                interactor.updateExistingNote(note)
            } else {
                DispatchQueue.main.async {
                    self.didSaveNote()
                }
            }
        } else {
            interactor.saveNewNote(
                title: title,
                description: description,
                created: created
            )
        }
    }
    
}

//MARK: - DetailInteractorOutput -
extension DetailPresenter: DetailInteractorOutput {
    func didSaveNote() {
    }
}
