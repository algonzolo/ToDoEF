//
//  CoreDataManger.swift
//  ToDoList
//
//  Created by Albert Garipov on 21.11.2024.
//

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    var persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "DataModel")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        }
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Error saving context: \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func addTodoItemsInBatch(_ todos: [ToDo]) {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        context.perform {
            for todo in todos {
                let newItem = NoteItem(context: context)
                newItem.title = todo.todo
                newItem.details = ""
                newItem.isCompleted = todo.completed
                newItem.createdAt = todo.created ?? Date()
            }
            do {
                try context.save()
            } catch {
                print("Error saving batch: \(error)")
            }
        }
    }
    
    func fetchTodoItems(sortedByCreatedAt ascending: Bool = true) -> [NoteItem] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NoteItem> = NoteItem.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: ascending)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let items = try context.fetch(fetchRequest)
            return items
        } catch {
            print("Error fetching TodoItems: \(error)")
            return []
        }
    }
    
    func deleteTodoItem(item: NoteItem) {
        let context = persistentContainer.viewContext
        context.delete(item)
        saveContext()
    }
    
    func addTodoItem(title: String, details: String, createdAt: Date, isCompleted: Bool, completion: @escaping () -> Void) {
        let context = persistentContainer.viewContext
        context.perform {
            let todoItem = NoteItem(context: context)
            todoItem.title = title
            todoItem.details = details
            todoItem.createdAt = createdAt
            todoItem.isCompleted = isCompleted
            
            do {
                try context.save()
                DispatchQueue.main.async {
                    completion()
                }
            } catch {
                print("Error saving item: \(error)")
            }
        }
    }
}
