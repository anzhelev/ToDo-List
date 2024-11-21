//
//  ContextMenuPreviewVC.swift
//  ToDo List
//
//  Created by Andrey Zhelev on 21.11.2024.
//
import UIKit

final class ContextMenuPreviewVC: UIViewController {
    private let params: TaskTableCellParams
    private let size: CGSize
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .whiteMainTextActive
        label.font = .taskTitle
        label.textAlignment = .left
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .whiteMainTextActive
        label.font = .taskDescription
        label.textAlignment = .left
        label.numberOfLines = 3
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .grayMainTextInactive
        label.font = .taskDescription
        label.textAlignment = .left
        return label
    }()
    
    init(params: TaskTableCellParams, size: CGSize) {
        self.params = params
        self.size = size
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    private func configureUI() {
        
        self.view.backgroundColor = .grayFooterBackground
        self.preferredContentSize = CGSize(width: self.size.width, height: self.size.height)
        
        switch params.status {
            
        case true:
            let attributeString = NSMutableAttributedString(string: params.title)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle,
                                         value: 2,
                                         range: NSRange(location: 0, length: attributeString.length)
            )
            titleLabel.attributedText = attributeString
            [titleLabel, descriptionLabel].forEach{
                $0.textColor = .grayMainTextInactive
            }
            
        case false:
            titleLabel.text = params.title
            [titleLabel, descriptionLabel].forEach{
                $0.textColor = .whiteMainTextActive
            }
        }
        
        descriptionLabel.text = params.description
        dateLabel.text = params.date
        
        [titleLabel, descriptionLabel, dateLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
            
            $0.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
            $0.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        }
        
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6).isActive = true
        dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 6).isActive = true
    }
}
