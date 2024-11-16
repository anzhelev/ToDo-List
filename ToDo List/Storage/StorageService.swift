//
//  StorageService.swift
//  ToDo List
//
//  Created by Andrey Zhelev on 15.11.2024.
//
import CoreData

struct TaskData {
    let id: UUID
}

protocol StorageServiceProtocol {

}

final class StorageService: StorageServiceProtocol {
    
    // MARK: - Public Properties
    var context: NSManagedObjectContext = AppDelegate.context
    
    // MARK: - Private Properties
    
}
