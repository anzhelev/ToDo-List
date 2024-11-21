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
    
    private let titleLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .left
        label.text = "Задачи"
        label.textColor = .whiteMainTextActive
        label.font = .mainTitle
        return label
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.searchTextField.delegate = self
        searchBar.backgroundColor = .clear
        
        let micImage = UIImage(systemName: "mic.fill")?.withTintColor(.grayMainTextInactive, renderingMode: .alwaysOriginal)
        searchBar.setImage(micImage, for: .bookmark, state: .normal)
        searchBar.showsBookmarkButton = true
        searchBar.searchTextField.layer.cornerRadius = 10
        searchBar.searchTextField.backgroundColor = .grayFooterBackground
        searchBar.searchTextField.tintColor = .grayMainTextInactive
        searchBar.searchTextField.textColor = .grayMainTextInactive
        searchBar.searchTextField.leftView?.tintColor = .grayMainTextInactive
        let attributeString = NSMutableAttributedString(string: "Search")
        attributeString.addAttribute(NSAttributedString.Key.foregroundColor,
                                     value: UIColor.grayMainTextInactive,
                                     range: NSRange(location: 0, length: attributeString.length
                                                   )
        )
        searchBar.searchTextField.attributedPlaceholder = attributeString        
        searchBar.showsCancelButton = false
        searchBar.searchTextField.borderStyle = .none
        searchBar.searchBarStyle = .minimal
        searchBar.enablesReturnKeyAutomatically = false
        searchBar.searchTextField.clearButtonMode = .unlessEditing
        return searchBar
    }()
    
    private lazy var taskTable: UITableView = {
        let table = UITableView()
        table.register(TaskTableCell.self, forCellReuseIdentifier: TaskTableCell.reuseIdentifier)
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = .blackMainBackground
        table.estimatedRowHeight = 100
        table.rowHeight = UITableView.automaticDimension
        table.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        table.separatorStyle = .singleLine
        table.separatorColor = .grayMainTextInactive
        table.showsVerticalScrollIndicator = false
        return table
        
    }()
    
    private let footer: UIView = {
        let footerView = UIView()
        footerView.backgroundColor = .grayFooterBackground
        return footerView
    }()
    
    private let divider: UIView = {
        let divider = UIView()
        divider.backgroundColor = .grayFooterDivider
        return divider
    }()
    
    private let tascCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .whiteMainTextActive
        label.font = .footer
        return label
    }()
    
    private lazy var newTaskCreationButton: UIButton = {
        guard let image = UIImage(named: "create") else {
            return UIButton()
        }
        let button = UIButton.systemButton(with: image, target: self, action: #selector(self.newTaskCreationButtonPressed))
        button.tintColor = .yellowSelection
        return button
    }()
    
    private var searchBarText: String? = nil {
        didSet {
            //            filterTasks()
        }
    }
    
    init(viewModel: ToDoListViewModelProtocol) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.isNavigationBarHidden = true
    }
    
    @objc private func newTaskCreationButtonPressed() {
        
    }
    
    // MARK: - Private Methods
    private func configureUI() {
        self.view.backgroundColor = .blackMainBackground
        
        for element in [titleLabel, searchBar, footer, taskTable, divider, tascCountLabel, newTaskCreationButton] {
            element.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(element)
        }
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            titleLabel.heightAnchor.constraint(equalToConstant: 41),
            
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            searchBar.heightAnchor.constraint(equalToConstant: 36),
            
            footer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            footer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -49),
            footer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            footer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            taskTable.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            taskTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            taskTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            taskTable.bottomAnchor.constraint(equalTo: footer.topAnchor),
            
            divider.topAnchor.constraint(equalTo: footer.topAnchor),
            divider.heightAnchor.constraint(equalToConstant: 0.33),
            divider.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tascCountLabel.centerYAnchor.constraint(equalTo: footer.centerYAnchor),
            tascCountLabel.centerXAnchor.constraint(equalTo: footer.centerXAnchor),
            
            newTaskCreationButton.widthAnchor.constraint(equalToConstant: 68),
            newTaskCreationButton.heightAnchor.constraint(equalToConstant: 44),
            newTaskCreationButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            newTaskCreationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource
extension ToDoListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getTableRowCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TaskTableCell.reuseIdentifier,
            for: indexPath
        ) as? TaskTableCell else {
            debugPrint("@@@ StatisticsViewController: Ошибка подготовки ячейки для таблицы.")
            return UITableViewCell()
        }
        cell.delegate = viewModel as? TaskTableCellDelegate
        let params = viewModel.getParams(for: indexPath.row)
        cell.configure(with: params)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ToDoListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        viewModel.charIsSelected (row: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let previewSize = tableView.rectForRow(at: indexPath).size
        
        return UIContextMenuConfiguration(previewProvider: { [weak self] in
            self?.viewModel.getPreview(for: indexPath.row, with: previewSize)
        },
                                          actionProvider: { actions in
            return UIMenu(children: [
                UIAction(title: "Редактировать"
                        ) { [weak self] _ in
                            
                        },
                
                UIAction(title: "Поделиться") { [weak self] _ in
                    
                },
                
                UIAction(title: "Удалить", attributes: .destructive) { [weak self] _ in
                    
                },
            ])
        })
        
        
    }
}

// MARK: - UISearchBarDelegate
extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBarText = searchText.lowercased()
        print(searchBarText ?? "")
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        
    }
}

// MARK: - UITextFieldDelegate
extension ToDoListViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
