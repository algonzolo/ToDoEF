//
//  DetailNoteView.swift
//  ToDoList
//
//  Created by Albert Garipov on 19.11.2024.
//

import UIKit

enum DetailScreenMode {
    case edit
    case create
}

final class DetailNoteView: UIView, UITextViewDelegate {
    // MARK: - Private properties -
    private let titleTextView = UITextView()
    private let detailTextView = UITextView()
    private let dateLabel = UILabel()
    
    private var titleTextViewHeightConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateTitleTextViewHeight()
    }
}

// MARK: - Public -
extension DetailNoteView {
    func configure(data: NoteItem) {
        titleTextView.text = data.title
        detailTextView.text = data.details
        
        guard let createdAt = data.createdAt else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateLabel.text = "\(dateFormatter.string(from: createdAt))"
    }
}

private extension DetailNoteView {
    func setupUI() {
        addSubview()
        setupConstraints()
        settingView()
    }
    
    func addSubview() {
        addSubview(titleTextView)
        addSubview(detailTextView)
        addSubview(dateLabel)
    }
    
    func setupConstraints() {
        titleTextView.translatesAutoresizingMaskIntoConstraints = false
        detailTextView.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleTextViewHeightConstraint = titleTextView.heightAnchor.constraint(equalToConstant: 50)
        titleTextViewHeightConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            titleTextView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            titleTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            dateLabel.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: 10),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            dateLabel.heightAnchor.constraint(equalToConstant: 20),
            
            detailTextView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 20),
            detailTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            detailTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            detailTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
    
    func settingView() {
        backgroundColor = .systemBackground
        titleTextView.textColor = UIColor.label
        titleTextView.font = UIFont.boldSystemFont(ofSize: 24)
        titleTextView.isScrollEnabled = false
        titleTextView.delegate = self
        titleTextView.textContainerInset = .zero
        titleTextView.textContainer.lineFragmentPadding = 0
        
        dateLabel.font = .preferredFont(forTextStyle: .caption1)
        dateLabel.textColor = .gray
        
        detailTextView.font = .preferredFont(forTextStyle: .subheadline)
    }
    
    func updateTitleTextViewHeight() {
        
        let targetWidth = bounds.width - 32
        let size = titleTextView.sizeThatFits(CGSize(width: targetWidth, height: CGFloat.greatestFiniteMagnitude))
        
        titleTextViewHeightConstraint?.constant = size.height
        layoutIfNeeded()
    }
}

extension DetailNoteView {
    func getTitleText() -> String? {
        return titleTextView.text
    }
    
    func getDescriptionText() -> String? {
        return detailTextView.text
    }
}

