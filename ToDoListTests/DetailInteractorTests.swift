//
//  DetailInteractorTests.swift
//  ToDoListTests
//
//  Created by Albert Garipov on 25.11.2024.
//

import XCTest
import CoreData
@testable import ToDoList

final class DetailInteractorTests: XCTestCase {
    private var sut: DetailInteractor!
    private var mockOutput: MockDetailInteractorOutput!
    private var testContext: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        
        sut = DetailInteractor()
        mockOutput = MockDetailInteractorOutput()
        sut.setOutput(output: mockOutput)
        
        let persistentContainer = NSPersistentContainer(name: "DataModel")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        persistentContainer.persistentStoreDescriptions = [description]
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Ошибка при настройке Core Data: \(error)")
            }
        }
        testContext = persistentContainer.viewContext
        
        CoreDataManager.shared.persistentContainer = persistentContainer
    }
    
    override func tearDown()  {
        super.tearDown()
        
        sut = nil
        mockOutput = nil
        testContext = nil
    }
    
    func testSaveNewNote() {
        // Arrange
        let testTitle = "Test Note"
        let testDescription = "This is a test note"
        let testDate = Date()
        
        // Act
        sut.saveNewNote(title: testTitle, description: testDescription, created: testDate)
        
        let expectation = self.expectation(description: "Ожидание сохранения заметки")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
        
        // Assert
        
        XCTAssertTrue(mockOutput.didSaveNoteCalled, "Метод didSaveNote должен быть вызван")
        
        // Проверяем, что заметка добавлена в Core Data
        let fetchRequest: NSFetchRequest<NoteItem> = NoteItem.fetchRequest()
        do {
            let notes = try self.testContext.fetch(fetchRequest)
            XCTAssertEqual(notes.count, 1, "Должна быть одна сохраненная заметка")
            XCTAssertEqual(notes.first?.title, testTitle, "Заголовок заметки должен совпадать")
            XCTAssertEqual(notes.first?.details, testDescription, "Описание заметки должно совпадать")
            XCTAssertEqual(notes.first?.createdAt, testDate, "Дата создания заметки должна совпадать")
        } catch {
            XCTFail("Ошибка при извлечении данных из Core Data: \(error)")
        }
    }
}

final class MockDetailInteractorOutput: DetailInteractorOutput {
    var didSaveNoteCalled = false
    
    func didSaveNote() {
        didSaveNoteCalled = true
    }
}

