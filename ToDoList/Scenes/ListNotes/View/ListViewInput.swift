//
//  ListViewInput.swift
//  ToDoList
//
//  Created by Albert Garipov on 19.11.2024.
//

import Foundation

protocol ListViewInput: AnyObject {
    var output: ListViewOutput? { get set }
    func updateView(with data: [NoteItem])
    func showLoading()
    func hideLoading()
}
