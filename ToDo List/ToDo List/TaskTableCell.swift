//
//  TaskTableCell.swift
//  ToDo List
//
//  Created by Andrey Zhelev on 18.11.2024.
//
import UIKit

protocol TaskTableCellDelegate: AnyObject {
    func completButtonPressed(for: Int)
}

final class TaskTableCell: UITableViewCell {
    
    // MARK: - Public Properties
    static let reuseIdentifier = "taskTableCell"
    weak var delegate: TaskTableCellDelegate?
    
    // MARK: - Private Properties
    private var rowIndex: Int = 0
    private lazy var completiionButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "circle"), for: .normal)
        button.tintColor = .grayMainTextInactive
        button.addTarget(self, action: #selector(completeButtonAction), for: .touchUpInside)
        return button
    }()
    
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
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUIElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configure(with params: TaskTableCellParams) {
        self.rowIndex = params.row
        
        switch params.status {
            
        case true:
            completiionButton.setImage(UIImage(named: "done"), for: .normal)
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
            completiionButton.setImage(UIImage(named: "circle"), for: .normal)
            titleLabel.text = params.title
            [titleLabel, descriptionLabel].forEach{
                $0.textColor = .whiteMainTextActive
            }
        }
        
        descriptionLabel.text = params.description
        dateLabel.text = params.date
    }
    
    // MARK: - IBAction
    @objc private func completeButtonAction() {
        delegate?.completButtonPressed(for: rowIndex)
    }
    
    // MARK: - Private Methods
    
    private func setUIElements() {
        self.backgroundColor = .blackMainBackground
        selectionStyle = .none
        
        
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.alignment = .leading
        vStack.spacing = 6
        
        [titleLabel, descriptionLabel, dateLabel].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            vStack.addArrangedSubview($0)
        }
        
        let vStackView = UIView()
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStackView.addSubview(vStack)
        
        let hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.alignment = .leading
        hStack.spacing = 8
        [completiionButton, vStackView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            hStack.addArrangedSubview($0)
        }
        
        hStack.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(hStack)
        
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: contentView.topAnchor),
            hStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            hStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            hStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            vStack.topAnchor.constraint(equalTo: vStackView.topAnchor, constant: 12),
            vStack.leadingAnchor.constraint(equalTo: vStackView.leadingAnchor),
            vStack.trailingAnchor.constraint(equalTo: vStackView.trailingAnchor),
            vStack.bottomAnchor.constraint(equalTo: vStackView.bottomAnchor, constant: -12)
        ])
    }
}
