//
//  DetailViewOutput.swift
//  ToDoList
//
//  Created by Albert Garipov on 19.11.2024.
//

import Foundation

protocol DetailViewOutput: AnyObject {
    func onViewDidLoad()
    func saveNote(title: String, description: String, created: Date, isEditMode: Bool)
}
