//
//  DetailViewInput.swift
//  ToDoList
//
//  Created by Albert Garipov on 19.11.2024.
//

import Foundation

protocol DetailViewInput: AnyObject {
    var output: DetailViewOutput? { get }
    func display(note: NoteItem?)
}
