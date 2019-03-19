//
//  ItemStore.swift
//  loaner
//
//  Created by Ian Birnam on 3/19/19.
//  Copyright © 2019 LinnierGames. All rights reserved.
//

import UIKit
import CoreData

enum FetchItemsResult {
    case success([Item])
    case failure(Error)
}


class ItemStore: NSObject {
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "LoanedItems")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("Error setting up Core Data (\(error)).")
            }
        }
        return container
    }()
    
    // MARK: - Save CoreData Context
    func saveContext() {
        let viewContext = persistentContainer.viewContext
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchPersistedData(completion: @escaping (FetchItemsResult) -> Void) {
        
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        let viewContext = persistentContainer.viewContext
        
        do {
            let allItems = try viewContext.fetch(fetchRequest)
            completion(.success(allItems))
        } catch {
            completion(.failure(error))
        }
    }
}
