//
//  DataManager.swift
//  BSEU
//
//  Created by Kirill Kubarskiy on 17.03.23.
//  Copyright © 2023 Kirill Kubarskiy. All rights reserved.
//

import Foundation

protocol DataManagerProtocol {
    //NetworkManager
    func fetchGroups(completion: @escaping ([Item]?) -> Void)
    func fetchTeachers(completion: @escaping([Teacher]) -> Void)
    func fetchEngTeachers(completion: @escaping([Teacher]) -> Void)
    func fetchSchedule(with id: String, completion: @escaping ([LessonsGrouped]) -> Void)
    //DatabaseManager
    func saveSavedGroups(_ item: Item)
    func getSavedGroups() -> [Item]?
    func removeSavedGroup(_ item: Item)
}

final class DataManager: DataManagerProtocol {

    private(set) var lessonsGrouped: [LessonsGrouped] = []
    private(set) var teachers: [Teacher] = []
    private(set) var groupsArray: [Item]?
    private let databaseManager: DatabaseManagerProtocol
    private let networkManager: NetworkManagerProtocol
    
    init(databaseManager: DatabaseManagerProtocol = DatabaseManager(), networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.databaseManager = databaseManager
        self.networkManager = networkManager
    }

    func fetchGroups(completion: @escaping ([Item]?) -> Void) {
        let isNetworkDataFetched = UserDefaults.standard.bool(forKey: "isNetworkDataFetched")
        if !isNetworkDataFetched, ReachabilityManager.shared.isConnectedToNetwork() {
            fetchGroupsFromNetwork(completion: completion)
        } else {
            fetchGroupsFromDatabase(completion: completion)
        }
    }

        
    private func fetchGroupsFromNetwork(completion: @escaping ([Item]?) -> Void) {
        print("fetchGroupsFromNetwork")
        networkManager.loadGroups { university in
            guard let university = university else { return }
            guard let univerGr = university.groups else { return }
            let items = self.networkManager.fetchItem(from: univerGr)
            self.updateDatabase(with: items)
            UserDefaults.standard.set(true, forKey: "isNetworkDataFetched")
            completion(self.groupsArray)
        }
    }

    
    private func fetchGroupsFromDatabase(completion: @escaping ([Item]?) -> Void) {
        print("fetchGroupsFromDatabase")
        if let groupsArray = self.groupsArray {
            completion(groupsArray)
        } else {
            self.groupsArray = databaseManager.getItems()
            completion(self.groupsArray)
        }
    }
    
    private func updateDatabase(with items: [Item]) {
        let missingItems = items.filter { !(self.groupsArray ?? []).contains($0) }
        if missingItems.count > 0 {
            databaseManager.deleteGroupEntity()
            missingItems.forEach { databaseManager.saveItem($0) }
            self.groupsArray = items
            print("updated database")
        } else {
            print("database contains all data")
        }
    }
    
    func fetchTeachers(completion: @escaping ([Teacher]) -> Void) {
        networkManager.loadTeachers { result in
            switch result {
            case .success(let teachers):
                self.teachers = teachers
                completion(teachers)
            case .failure(let error):
                print("Error loading teachers: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchEngTeachers(completion: @escaping ([Teacher]) -> Void) {
        networkManager.loadEngTeachers { result in
            switch result {
            case .success(let teachers):
                self.teachers = teachers
                completion(teachers)
            case .failure(let error):
                print("Error loading teachers: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchSchedule(with id: String, completion: @escaping ([LessonsGrouped]) -> Void) {
        networkManager.loadSchedule(with: id) { [weak self] lessonsGrouped in
            guard let lessonsGrouped = lessonsGrouped else { return }
            self?.lessonsGrouped = lessonsGrouped
            completion(lessonsGrouped)
        }
    }

    func saveSavedGroups(_ item: Item) {
        databaseManager.saveSavedGroups(item)
    }
    
    func getSavedGroups() -> [Item]? {
        return databaseManager.getSavedGroups()
    }
    
    func removeSavedGroup(_ item: Item) {
        databaseManager.removeSavedGroup(item)
    }
}

