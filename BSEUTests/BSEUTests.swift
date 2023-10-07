//
//  BSEUTests.swift
//  BSEUTests
//
//  Created by Kirill Kubarskiy on 18.03.23.
//  Copyright © 2023 Kirill Kubarskiy. All rights reserved.
//

import XCTest
@testable import BSEU
final class ViewModelsTests: XCTestCase {
    
    var sutGroupsVM: GroupsViewModel!
    var sutTeachersVM: TeachersViewModel!
    var sutScheduleVM: ScheduleViewModel!
    
    var mockDataManager: MockDataManager!
    
    override func setUp() {
        super.setUp()
        mockDataManager = MockDataManager()
        sutGroupsVM = GroupsViewModel(dataManager: mockDataManager)
        sutTeachersVM = TeachersViewModel(dataManager: mockDataManager)
        sutScheduleVM = ScheduleViewModel(dataManager: mockDataManager)
    }
    
    override func tearDown() {
        mockDataManager = nil
        sutGroupsVM = nil
        sutTeachersVM = nil
        sutScheduleVM = nil
        super.tearDown()
    }
    
    func testFetchGroups_WhenSuccessful_ReturnsGroups() {
        // Given
        let expectedGroups = [Item(id: "9387", name: "Group 1", number: 1), Item(id: "9387", name: "Group 2", number: 1)]
        mockDataManager.items = expectedGroups
        
        let expectation = self.expectation(description: "Fetch groups completed")
        
        // When
        sutGroupsVM.fetchGroups {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
        
        // Then
        XCTAssertEqual(sutGroupsVM.groups, expectedGroups)
    }
    
    func testGetSavedGroups_ReturnsGroups() {
        // Given
        let expectedGroups = [Item(id: "9387", name: "Group 1", number: 1), Item(id: "9387", name: "Group 2", number: 1)]
        mockDataManager.savedGroups = expectedGroups
        
        // When
        let savedGroups = sutGroupsVM.getSavedGroups()
        
        // Then
        XCTAssertEqual(savedGroups, expectedGroups)
    }
    
    func testSaveSavedGroup_SavesGroup() {
        // Given
        let groupToSave = Item(id: "9387", name: "Group 1", number: 1)
        
        // When
        sutGroupsVM.saveSavedGroup(groupToSave)
        
        // Then
        XCTAssertTrue(mockDataManager.savedGroups.contains(groupToSave))
    }
    
    func testRemoveSavedGroup_RemovesGroup() {
        // Given
        let groupToRemove = Item(id: "9387", name: "Group 1", number: 1)
        mockDataManager.savedGroups = [groupToRemove, Item(id: "9387", name: "Group 2", number: 1)]
        
        // When
        sutGroupsVM.removeSavedGroup(groupToRemove)
        
        // Then
        XCTAssertFalse(mockDataManager.savedGroups.contains(groupToRemove))
    }
    
    func testFetchTeachers() {
        let expectation = self.expectation(description: "Fetch teachers")
        
        sutTeachersVM.fetchTeachers { teachers in
            XCTAssertEqual(teachers.count, 2)
            XCTAssertEqual(teachers[0].name, "Kirill")
            XCTAssertEqual(teachers[1].name, "John 2")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testFetchSchedule() {
            let expectation = XCTestExpectation(description: "Completion called")
            
            sutScheduleVM.fetchSchedule(with: "123") {
                expectation.fulfill()
            }
    
            XCTAssertTrue(mockDataManager.fetchScheduleCalled)
            XCTAssertEqual(sutScheduleVM.lessonsGrouped.count, 1)
            XCTAssertEqual(sutScheduleVM.lessonsGrouped[0].date, "2022.03.16")
            
            wait(for: [expectation], timeout: 1)
        }
}

// Mock implementation of the DataManagerProtocol for testing purposes
class MockDataManager: DataManagerProtocol {
  func fetchEngSchedule(with id: String, completion: @escaping ([BSEU.LessonsGrouped]) -> Void) {}
  func saveGroupID(_ id: String, _ name: String) {}
  func fetchGroupID() -> [BSEU.SavedGroupID]? { return nil }

    
    var items: [Item]?
    var savedGroups: [Item] = []
    
    func fetchGroups(completion: @escaping ([Item]?) -> Void) {
        completion(items)
    }
    
    func getSavedGroups() -> [Item]? {
        return savedGroups
    }
    
    func saveSavedGroups(_ group: Item) {
        savedGroups.append(group)
    }
    
    func removeSavedGroup(_ item: Item) {
        savedGroups.removeAll(where: { $0.id == item.id })
    }
    
    func fetchTeachers(completion: @escaping ([Teacher]) -> Void) {
        let teachers = [
            Teacher(name: "Kirill", pictureURL: "Abdulla", positionAndDegree: "Student"),
            Teacher(name: "John 2", pictureURL: "urlForPicture2", positionAndDegree: "Teacher")
        ]
        completion(teachers)
    }
    
    func fetchEngTeachers(completion: @escaping ([Teacher]) -> Void) {
        let teachers = [
            Teacher(name: "Kirill", pictureURL: "Abdulla", positionAndDegree: "Student"),
            Teacher(name: "John 2", pictureURL: "urlForPicture2", positionAndDegree: "Teacher")
        ]
        completion(teachers)
    }
    
    var fetchScheduleCalled = false
 
    func fetchSchedule(with id: String, completion: @escaping ([BSEU.LessonsGrouped]) -> Void) {
        fetchScheduleCalled = true
                let lessonsGrouped = [LessonsGrouped(date: "2022.03.16", lessons: [])]
                completion(lessonsGrouped)
    }
}
