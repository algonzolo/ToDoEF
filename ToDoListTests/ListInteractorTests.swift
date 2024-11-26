//
//  ListInteractorTests.swift
//  ToDoListTests
//
//  Created by Albert Garipov on 19.11.2024.
//

import XCTest
import CoreData
@testable import ToDoList

final class ListInteractorTest: XCTestCase {
    private var sut: ListInteractor!
    
    override func setUp() {
        super.setUp()
        clearCoreData()
        sut = ListInteractor()
    }
    
    override func tearDown()  {
        super.tearDown()
        sut = nil
    }
    
    func clearCoreData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NoteItem")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            XCTFail("Не удалось очистить Core Data: \(error)")
        }
    }

    
    func testDeleteTask() {
        // Arrange
        let mockOutput = MockListInteractorOutput()
        sut.outPut = mockOutput // Подключаем мок

        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        // Создаем заметки через контекст
        let task1 = NSEntityDescription.insertNewObject(forEntityName: "NoteItem", into: context) as! NoteItem
        task1.title = "Task 1"
        task1.details = "Details 1"
        task1.isCompleted = false
        task1.createdAt = Date()
        
        let task2 = NSEntityDescription.insertNewObject(forEntityName: "NoteItem", into: context) as! NoteItem
        task2.title = "Task 2"
        task2.details = "Details 2"
        task2.isCompleted = false
        task2.createdAt = Date()
        
        let task3 = NSEntityDescription.insertNewObject(forEntityName: "NoteItem", into: context) as! NoteItem
        task3.title = "Task 3"
        task3.details = "Details 3"
        task3.isCompleted = false
        task3.createdAt = Date()
        
        // Сохраняем контекст
        try? context.save()

        // Проверяем начальные данные
        let initialNotes = sut.fetchData()
        XCTAssertEqual(initialNotes.count, 3, "Перед удалением должно быть три заметки")

        // Act
        sut.deleteItem(at: 1, from: initialNotes) // Удаляем вторую заметку

        // Assert
        let updatedNotes = sut.fetchData()
        XCTAssertEqual(updatedNotes.count, 2, "После удаления должно остаться две заметки")
        
        XCTAssertTrue(mockOutput.didLoadDataCalled, "Метод didLoadData должен быть вызван")
        XCTAssertEqual(mockOutput.loadedData.count, 2, "Метод didLoadData должен передать список из двух заметок")
        XCTAssertFalse(updatedNotes.contains { $0.title == "Task 2" }, "Заметка 'Task 2' должна быть удалена")
    }

}

final class MockListInteractorOutput: ListInteractorOutput {
    var didLoadDataCalled = false
    var loadedData: [NoteItem] = []
    
    var didUpdateItemCalled = false
    var updatedItem: NoteItem?
    
    func didLoadData(_ data: [NoteItem]) {
        didLoadDataCalled = true
        loadedData = data
    }
    
    func didUpdateItem(_ item: NoteItem) {
        didUpdateItemCalled = true
        updatedItem = item
    }
}
