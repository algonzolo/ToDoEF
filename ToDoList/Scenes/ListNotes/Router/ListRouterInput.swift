//
//  ListRouterInput.swift
//  ToDoList
//
//  Created by Albert Garipov on 19.11.2024.
//

import Foundation

protocol ListRouterInput {
    func openDetailScreen(note: NoteItem?, mode: DetailScreenMode)
}
