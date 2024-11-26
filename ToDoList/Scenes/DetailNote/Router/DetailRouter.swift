//
//  DetailRouter.swift
//  ToDoList
//
//  Created by Albert Garipov on 19.11.2024.
//

import UIKit

final class DetailRouter {
    weak var detailViewController: DetailVC?
    weak var parentPresenter: ListViewOutput?
}
//MARK: - Public -
extension DetailRouter {
    func setViewController(viewController: DetailVC) {
        detailViewController = viewController
    }
}
//MARK: - DetailRouterInput -
extension DetailRouter: DetailRouterInput {
    func notifyParentToReload() {
        parentPresenter?.reloadData()
    }
}
