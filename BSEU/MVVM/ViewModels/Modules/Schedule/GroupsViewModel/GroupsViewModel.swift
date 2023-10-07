//
//  GroupsViewModel.swift
//  BSEU
//
//  Created by Kirill Kubarskiy on 17.03.23.
//  Copyright © 2023 Kirill Kubarskiy. All rights reserved.
//

import Foundation

final class GroupsViewModel {
    
    private let dataManager: DataManagerProtocol
    init(dataManager: DataManagerProtocol = DataManager()) {
        self.dataManager = dataManager
    }
    
    var groups: [Item] = []
    
    func fetchGroups(completion: @escaping() -> Void) {
        dataManager.fetchGroups { [weak self] items in
            guard let items = items else { return }
            self?.groups = items
            completion()
        }
    }
    
    func getSavedGroups() -> [Item]? {
        return dataManager.getSavedGroups()
    }
    
    func saveSavedGroup(_ group: Item) {
        dataManager.saveSavedGroups(group)
    }
    
    func removeSavedGroup(_ item: Item) {
        dataManager.removeSavedGroup(item)
    }

    func getSavedGroupID() -> [SavedGroupID]? {
       dataManager.fetchGroupID()
    }

    func saveGroupID(_ id: String, _ name: String) {
      dataManager.saveGroupID(id, name)
    }
}

