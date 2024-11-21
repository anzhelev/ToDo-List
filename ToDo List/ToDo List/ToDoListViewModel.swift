//
//  ToDoViewModel.swift
//  ToDo List
//
//  Created by Andrey Zhelev on 16.11.2024.
//
import Foundation
import UIKit

protocol ToDoListViewModelProtocol {
    func getTableRowCount() -> Int
    func getParams(for row: Int) -> TaskTableCellParams
    func getPreview(for row: Int, with size: CGSize) -> UIViewController
}

final class ToDoListViewModel: ToDoListViewModelProtocol {
    
    var view: ToDoListViewControllerProtocol?
    private let storageService: StorageServiceProtocol
    
    
    init(storageService: StorageServiceProtocol) {
        self.storageService = storageService
    }
    
    // MARK: - States
    private enum ToDoListViewModelState {
        //        case loadNextPage,                // стейт запроса данных или сети
        //             loadFailed(Error),           // стейт обработки ошибки при неудачной загрузке данных
        //             dataLoaded(CharactersData)   // стейт обработки данных при удачной загрузке
    }
    
    // MARK: - Public Methods
    func viewWillAppear() {
        
    }
    
    func getTableRowCount() -> Int {
        5        
    }
    
    func getParams(for row: Int) -> TaskTableCellParams {
        
        return .init(
            row: row,
            status: row % 2 == 0,
            title: "Title",
            description: "Сходить в спортзал или сделать тренировку дома. Не забыть про разминку и растяжку! Не забыть про разминку и растяжку!",
            date: "02/10/24"
        )
    }
    
    func getPreview(for row: Int, with size: CGSize) -> UIViewController {
        ContextMenuPreviewVC(params: .init(row: row,
                                           status: row % 2 == 0,
                                           title: "Title",
                                           description: "Сходить в спортзал или сделать тренировку дома. Не забыть про разминку и растяжку! Не забыть про разминку и растяжку!",
                                           date: "02/10/24"
                                          ),
                             size: size
        )
    }
}

// MARK: - TaskTableCellDelegate
extension ToDoListViewModel: TaskTableCellDelegate {
    func completButtonPressed(for row: Int) {
        print ("нажата кнопка в строке \(row)")
    }
}
