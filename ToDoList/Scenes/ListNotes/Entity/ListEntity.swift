//
//  ListEntity.swift
//  ToDoList
//
//  Created by Albert Garipov on 19.11.2024.
//

import Foundation

struct TodoResponse: Codable {
    let todos: [ToDo]
}

struct ToDo: Codable {
    let id: Int
    var todo: String
    var created: Date?
    var completed: Bool
}
