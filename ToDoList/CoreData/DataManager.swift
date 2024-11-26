//
//  DataManager.swift
//  ToDoList
//
//  Created by Albert Garipov on 21.11.2024.
//

import Foundation

class APIClient {
    func fetchTodos(completion: @escaping ([ToDo]) -> Void) {
        let url = URL(string: "https://dummyjson.com/todos")!
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(TodoResponse.self, from: data)
                    completion(response.todos)
                } catch {
                    print("Failed to decode data: \(error)")
                    completion([])
                }
            } else {
                completion([])
            }
        }.resume()
    }
}

class DataManager {
    let apiClient = APIClient()
    
    func loadInitialData(completion: @escaping () -> Void) {
        apiClient.fetchTodos { todos in
            CoreDataManager.shared.addTodoItemsInBatch(todos)
            completion()
        }
    }
}
