//
//  AssemblyDetailNoteModule.swift
//  ToDoList
//
//  Created by Albert Garipov on 19.11.2024.
//

import Foundation

final class AssemblyDetailNoteModule {
    static func assembleDetailViewConsroller(note: NoteItem?, mode: DetailScreenMode) -> DetailVC {
        let view = DetailVC()
        view.setMode(mode)
        
        let interactor = DetailInteractor()
        let router = DetailRouter()
        let presenter = DetailPresenter(view: view,
                                        interactor: interactor,
                                        router: router,
                                        note: note,
                                        mode: mode)
        view.setOutput(output: presenter)
        view.router = router
        interactor.setOutput(output: presenter)
        router.setViewController(viewController: view)
        return view
    }
}
