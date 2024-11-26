//
//  AssemblyListNotesModule.swift
//  ToDoList
//
//  Created by Albert Garipov on 19.11.2024.
//

import Foundation
import UIKit

final class AssemblyListModule {
    static func assembleListViewConsroller() -> ListVC {
        
        let view = ListVC()
        let interactor = ListInteractor()
        let router = ListRouter()
        let presenter = ListPresenter(view: view,
                                      interactor: interactor,
                                      router: router)
        view.setOutput(output: presenter)
        interactor.outPut = presenter
        router.listScreenViewController = view
        return view
    }
}
