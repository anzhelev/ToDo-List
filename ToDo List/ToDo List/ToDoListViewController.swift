//
//  ToDoListViewController.swift
//  ToDo List
//
//  Created by Andrey Zhelev on 15.11.2024.
//

import UIKit

protocol ToDoListViewControllerProtocol {
    
}

class ToDoListViewController: UIViewController, ToDoListViewControllerProtocol {
    private let viewModel: ToDoListViewModelProtocol
    
    init(viewModel: ToDoListViewModelProtocol) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .gray
    }


}

