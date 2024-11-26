//
//  ListNotesCell.swift
//  ToDoList
//
//  Created by Albert Garipov on 19.11.2024.
//

import UIKit
protocol ListNotesCellDelegate: AnyObject {
    func didToggleCheckmark(for indexPath: IndexPath, isCompleted: Bool)
}

fileprivate enum Constants {
    static let stackViewSpacing: CGFloat = 6
    static let nameLabelFontSize: CGFloat = 16
    static let descriptionLabelFontSize: CGFloat = 12
    static let dateLabelFontSize: CGFloat = 12
}

final class ListNotesCell: UITableViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
    weak var delegate: ListNotesCellDelegate?
    private var indexPath: IndexPath?
    
    // MARK: - Private properties -
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let dateLabel = UILabel()
    private let checkmarkButton = UIButton()
    private let bottomView = UIView()
    private let stackView = UIStackView()
    private(set) var isCheckmarkTapped: Bool = false
    private var isCompleted: Bool = false
    
    // MARK: - Life cycle -
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.layoutIfNeeded()
    }
}

// MARK: - Public -
extension ListNotesCell {
    
    func configure(data: NoteItem, indexPath: IndexPath) {
        self.indexPath = indexPath
        
        titleLabel.text = data.title
        descriptionLabel.text = data.details
        isCompleted = data.isCompleted
        
        guard let createdAt = data.createdAt else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateLabel.text = "\(dateFormatter.string(from: createdAt))"
        updateUI(isCompleted: isCompleted)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isCompleted = false
        indexPath = nil
        titleLabel.text = nil
        titleLabel.attributedText = nil
        descriptionLabel.text = nil
        dateLabel.text = nil
        checkmarkButton.setImage(nil, for: .normal)
        checkmarkButton.tintColor = nil
        delegate = nil
    }
}

// MARK: - UI -
private extension ListNotesCell {
    func setupUI() {
        addSubviews()
        setupConstraints()
        setupStackView()
        setupTitleLabel()
        setupDestinationLabel()
        setupDateLabel()
        setupBottomView()
        setupCheckmark()
        settingCell()
    }
    
    func addSubviews() {
        addSubview(checkmarkButton)
        addSubview(stackView)
        addSubview(bottomView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(dateLabel)
    }
    
    func setupConstraints() {
        checkmarkButton.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            checkmarkButton.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            checkmarkButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            checkmarkButton.heightAnchor.constraint(equalToConstant: 24),
            checkmarkButton.widthAnchor.constraint(equalToConstant: 24),
            
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: checkmarkButton.trailingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            
            bottomView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            bottomView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            bottomView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    func setupStackView() {
        stackView.axis = .vertical
        stackView.spacing = Constants.stackViewSpacing
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
    }
    
    func setupTitleLabel() {
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont(name: "SFUIDisplay-Bold", size: Constants.nameLabelFontSize)
    }
    
    func setupDestinationLabel() {
        descriptionLabel.textAlignment = .left
        descriptionLabel.font = UIFont.systemFont(ofSize: Constants.descriptionLabelFontSize)
    }
    
    func setupDateLabel() {
        dateLabel.textAlignment = .left
        dateLabel.font = UIFont.systemFont(ofSize: Constants.dateLabelFontSize)
    }
    
    func setupCheckmark() {
        contentView.isUserInteractionEnabled = true
        bringSubviewToFront(checkmarkButton)
        checkmarkButton.addTarget(self, action: #selector(checkmarkTapped), for: .touchUpInside)
    }
    
    func setupBottomView() {
        bottomView.backgroundColor = .gray
    }
    
    func settingCell() {
        backgroundColor = .clear
        titleLabel.textColor = UIColor.label
        descriptionLabel.textColor = UIColor.secondaryLabel
        dateLabel.textColor = UIColor.tertiaryLabel
        bottomView.backgroundColor = UIColor.separator
    }
    
    private func updateUI(isCompleted: Bool) {
        let imageName = isCompleted ? "checkmark.circle" : "circle"
        let imageColor = isCompleted ? UIColor.systemYellow : UIColor.systemGray
        
        let configuration = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
        let checkmark = UIImage(systemName: imageName, withConfiguration: configuration)?.withRenderingMode(.alwaysTemplate)
        
        checkmarkButton.setImage(checkmark, for: .normal)
        checkmarkButton.tintColor = imageColor
        
        guard let text = titleLabel.text else { return }
        if !isCompleted {
            titleLabel.attributedText = NSAttributedString(
                string: text,
                attributes: [
                    .strikethroughStyle: [],
                    .foregroundColor: UIColor.label
                ]
            )
        } else {
            titleLabel.attributedText = NSAttributedString(
                string: text,
                attributes: [
                    .strikethroughStyle: NSUnderlineStyle.single.rawValue,
                    .foregroundColor: UIColor.secondaryLabel
                ]
            )
        }
    }
    
    @objc private func checkmarkTapped(_ sender: UIButton) {
        isCompleted.toggle()
        updateUI(isCompleted: isCompleted)
        
        if let indexPath = indexPath {
            delegate?.didToggleCheckmark(for: indexPath, isCompleted: isCompleted)
        }
    }
}
