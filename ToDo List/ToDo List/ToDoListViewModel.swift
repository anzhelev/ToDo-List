//
//  ToDoViewModel.swift
//  ToDo List
//
//  Created by Andrey Zhelev on 16.11.2024.
//

protocol ToDoListViewModelProtocol {
    
}

final class ToDoListViewModel: ToDoListViewModelProtocol {
    
    var view: ToDoListViewControllerProtocol?
    private let storageService: StorageServiceProtocol
    
    
    init(storageService: StorageServiceProtocol) {
        self.storageService = storageService
    }
    
}
