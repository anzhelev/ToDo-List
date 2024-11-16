//
//  ToDoListAssembler.swift
//  ToDo List
//
//  Created by Andrey Zhelev on 15.11.2024.
//
import UIKit

final class ToDoListAssembler {
    private let storageService = StorageService()

    public func build() -> UIViewController {
        let viewModel = ToDoListViewModel(
            storageService: storageService
        )

        let viewController = ToDoListViewController(viewModel: viewModel)
        viewModel.view = viewController
        return viewController
    }
}
