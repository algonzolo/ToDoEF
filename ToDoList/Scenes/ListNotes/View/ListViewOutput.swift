//
//  ListViewOutput.swift
//  ToDoList
//
//  Created by Albert Garipov on 19.11.2024.
//

import Foundation

protocol ListViewOutput: AnyObject {
    func onViewDidLoad()
    func deleteItem(at index: Int, from items: [NoteItem])
    func didTapCreateButton()
    func didSelectNote(_ note: NoteItem)
    func reloadData()
    func updateCheckmark(for note: NoteItem, isCompleted: Bool)
}
