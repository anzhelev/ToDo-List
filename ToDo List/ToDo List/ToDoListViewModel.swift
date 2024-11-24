//
//  ToDoViewModel.swift
//  ToDo List
//
//  Created by Andrey Zhelev on 16.11.2024.
//
import Foundation
import UIKit

protocol ToDoListViewModelProtocol {
    var itemsAdded: Observable<[IndexPath]> { get set }
    func viewWillAppear()
    func getTableRowCount() -> Int
    func getParams(for row: Int) -> ToDoItemCellParams
    func getPreview(for row: Int, with size: CGSize) -> UIViewController
    func editItemButtonPressed(for item: Int)
    func shareItemButtonPressed(for item: Int)
    func deleteItemButtonPressed(for item: Int)
}

final class ToDoListViewModel: ToDoListViewModelProtocol {
    
    // MARK: - Public Properties
    var view: ToDoListViewControllerProtocol?
    var itemsAdded: Observable<[IndexPath]> = Observable(nil)
    var itemsDeleted: Observable<[IndexPath]> = Observable(nil)
    var itemsUpdated: Observable<[IndexPath]> = Observable(nil)
    
    // MARK: - Private Properties
    private let storageService: StorageServiceProtocol
    private var todos: [ToDoItem] = []
    private let networkClient = NetworkClient.networkClient
    private var state: ToDoListViewModelState? {
        didSet {
            stateDidChanged()
        }
    }
    
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yy"
        return df
    }()
    
    
    init(storageService: StorageServiceProtocol) {
        self.storageService = storageService
    }
    
    // MARK: - States
    private enum ToDoListViewModelState {
        case loadFromDummyApi                // стейт запроса данных из сети
        //             loadFailed(Error),           // стейт обработки ошибки при неудачной загрузке данных
        //             dataLoaded(Data)   // стейт обработки данных при удачной загрузке
    }
    
    // MARK: - Public Methods
    func viewWillAppear() {
        state = .loadFromDummyApi
    }
    
    func getTableRowCount() -> Int {
        todos.count
    }
    
    func getParams(for row: Int) -> ToDoItemCellParams {
        let item = todos[row]
        return .init(
            row: row,
            status: item.status,
            title: item.title,
            description: item.description,
            date: getFormattedString(from: item.date)
        )
    }
    
    func getPreview(for row: Int, with size: CGSize) -> UIViewController {
        let item = todos[row]
        return ContextMenuPreviewVC(params: .init(row: row,
                                                  status: item.status,
                                                  title: item.title,
                                                  description: item.description,
                                                  date: getFormattedString(from: item.date)
                                                 ),
                                    size: size
        )
    }
    
    func editItemButtonPressed(for item: Int) {
        
    }
    
    func shareItemButtonPressed(for item: Int) {
        
    }
    
    func deleteItemButtonPressed(for item: Int) {
        
    }
    
    // MARK: - Private Methods
    private func stateDidChanged() {
        switch state {
        case .loadFromDummyApi:
            networkClient.loadToDos(requestUrl: NetworkConstants.endPoint) { [weak self] result in
                switch result {
                case .success(let newData):
                    self?.todos = newData
                    var newIndexes  = [IndexPath]()
                    for newItem in 0...newData.count-1 {
                        newIndexes.append(IndexPath(row: newItem, section: 0))
                    }
                    self?.itemsAdded.value = newIndexes
                    
                    //                self?.state = .dataLoaded(newData)
                case .failure(let error):
                    print(error)
                    //                self?.state = .loadFailed(error)
                }
            }
            
        case .none:
            assertionFailure("StatisticsPresenter can't move to initial state")
        }
    }
    
    private func getFormattedString(from date: Date) -> String {
        return dateFormatter.string(from: date)
    }
}

// MARK: - TaskTableCellDelegate
extension ToDoListViewModel: TaskTableCellDelegate {
    func completButtonPressed(for row: Int) {
        print ("нажата кнопка в строке \(row)")
    }
}
