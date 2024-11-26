//
//  ListInteractorOutput.swift
//  ToDoList
//
//  Created by Albert Garipov on 19.11.2024.
//

import Foundation

protocol ListInteractorOutput: AnyObject {
    func didLoadData(_ data: [NoteItem])
    func didUpdateItem(_ item: NoteItem)
}
