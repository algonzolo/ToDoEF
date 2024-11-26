//
//  DetailVC.swift
//  ToDoList
//
//  Created by Albert Garipov on 19.11.2024.
//

import UIKit

final class DetailVC: UIViewController {
    //MARK: - Private properties -
    
    private let contenView = DetailNoteView()
    private var mode: DetailScreenMode = .edit
    var output: DetailViewOutput?
    var router: DetailRouterInput?
    
    override func loadView() {
        super.loadView()
        view = contenView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        output?.onViewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)

            if isMovingFromParent {
                saveButtonTapped()
            }
        }
    
    func setMode(_ mode: DetailScreenMode) {
        self.mode = mode
    }
}

//MARK: - Public -

extension DetailVC {
    func setOutput(output: DetailViewOutput) {
        self.output = output
    }
}

//MARK: - DetailViewInput -
extension DetailVC: DetailViewInput {
    func display(note: NoteItem?) {
        guard let note  = note else { return }
        contenView.configure(data: note)
    }
}

//MARK: - Private -
private extension DetailVC {
    
    @objc private func saveButtonTapped() {
        guard let title = contenView.getTitleText(), !title.isEmpty,
              let description = contenView.getDescriptionText() else {
            navigationController?.popViewController(animated: true)
            return
        }
        
        switch mode {
        case .edit:
            output?.saveNote(
                title: title,
                description: description,
                created: Date(),
                isEditMode: true
            )
            router?.notifyParentToReload()
            navigationController?.popViewController(animated: true)
        case .create:
            let createdAt = Date()
            CoreDataManager.shared.addTodoItem(
                title: title,
                details: description,
                createdAt: createdAt,
                isCompleted: false
            ) { [weak self] in
                self?.router?.notifyParentToReload()
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
}
