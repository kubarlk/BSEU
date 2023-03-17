//
//  DatabaseManager.swift
//  BSEU
//
//  Created by Kirill Kubarskiy on 17.03.23.
//  Copyright © 2023 Kirill Kubarskiy. All rights reserved.
//

import CoreData
import UIKit
import Foundation

protocol DatabaseManagerProtocol {
    func saveSavedGroups(_ item: Item)
    func getSavedGroups() -> [Item]?
    func removeSavedGroup(_ item: Item)
    func getItems() -> [Item]?
    func saveItem(_ item: Item)
    func deleteGroupEntity()
}

final class DatabaseManager: DatabaseManagerProtocol {
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Group")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
        })
        return container
    }()
    
    private func saveContext() {
        print("saveContext")
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    //MARK: SAVED groups
    func saveSavedGroups(_ item: Item) {
        let managedContext = persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "SavedGroupEntity", in: managedContext) else { return }
        
        let group = NSManagedObject(entity: entity, insertInto: managedContext)
        
        group.setValue(item.name, forKey: "name")
        group.setValue(item.number, forKey: "number")
        group.setValue(item.id, forKey: "id")
        
        do {
            try managedContext.save()
            print("Saved")
        } catch let error as NSError {
            print("Error - \(error)")
        }
        print("SAVED ITEM \(item)")
    }
    
    func getSavedGroups() -> [Item]? {
        
        let managedContext = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SavedGroupEntity")
        
        do {
            let objects = try managedContext.fetch(fetchRequest)
            var items = [Item]()
            for object in objects {
                guard let name = object.value(forKey: "name") as? String,
                      let id = object.value(forKey: "id") as? String,
                      let number = object.value(forKey: "number") as? Int
                else { return nil }
                let item = Item(id: id, name: name, number: number)
                items.append(item)
            }
            return items
        } catch let error as NSError {
            print("Error - \(error)")
        }
        return nil
    }
    
    func removeSavedGroup(_ item: Item) {
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedGroupEntity")
        fetchRequest.predicate = NSPredicate(format: "id == %@", item.id)
        
        do {
            let results = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            results?.forEach { managedContext.delete($0) }
            try managedContext.save()
            print("Removed")
        } catch let error as NSError {
            print("Error - \(error)")
        }
        print("REMOVED ITEM \(item)")
    }

    
    
    //MARK: ITEM
    func saveItem(_ item: Item) {
        let managedContext = persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "GroupEntity", in: managedContext) else { return }
        
        let group = NSManagedObject(entity: entity, insertInto: managedContext)
        
        group.setValue(item.name, forKey: "name")
        group.setValue(item.number, forKey: "number")
        group.setValue(item.id, forKey: "id")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Error - \(error)")
        }
    }
    
    func getItems() -> [Item]? {
        let managedContext = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "GroupEntity")
        
        do {
            let objects = try managedContext.fetch(fetchRequest)
            var items = [Item]()
            for object in objects {
                guard let name = object.value(forKey: "name") as? String,
                      let id = object.value(forKey: "id") as? String,
                      let number = object.value(forKey: "number") as? Int
                else { return nil }
                let item = Item(id: id, name: name, number: number)
                items.append(item)
            }
            return items
        } catch let error as NSError {
            print("Error - \(error)")
        }
        return nil
    }
    
    //MARK: delete entity "GroupEntity"
    func deleteGroupEntity() {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "GroupEntity")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(batchDeleteRequest)
        } catch {
            print("Error deleting GroupEntity: \(error.localizedDescription)")
        }
    }

    func clearAllCoreData() {
        print("clearAllCoreData 1")
        let entities = persistentContainer.managedObjectModel.entities
        entities.compactMap({ $0.name }).forEach(clearDeepObjectEntity)
    }

    private func clearDeepObjectEntity(_ entity: String) {
        let context = persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
}
