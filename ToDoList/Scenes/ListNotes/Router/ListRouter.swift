//
//  ListRouter.swift
//  ToDoList
//
//  Created by Albert Garipov on 19.11.2024.
//

final class ListRouter {
    weak var listScreenViewController: ListVC?
}

//MARK: - ListRouterInput -
extension ListRouter: ListRouterInput {
    func openDetailScreen(note: NoteItem?, mode: DetailScreenMode) {
        let detailViewController = AssemblyDetailNoteModule.assembleDetailViewConsroller(note: note, mode: mode)
        listScreenViewController?.navigationItem.backButtonTitle = "Назад"
        listScreenViewController?.navigationController?.navigationBar.tintColor = .systemYellow
        
        if let detailRouter = detailViewController.router as? DetailRouter {
            detailRouter.parentPresenter = listScreenViewController?.output
        }
        listScreenViewController?.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
