//
//  SkillCollectionViewCell.swift
//  Profile | Surf Summer School 2023
//
//  Created by Ka4aH on 01.08.2023.
//

import UIKit

class SkillCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "SkillCell"

    private lazy var skillTextLabel: UILabel = {
        let label = UILabel()
        label.font = .sfproRegular(size: 14)
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .black
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [skillTextLabel, closeButton])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    
    var isEditing: Bool = false {
        didSet {
            closeButton.isHidden = !isEditing
        }
    }
    
    var deleteButtonTappedHandler: (() -> Void)?
    private var cellWidth: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(with skill: String, maxWidth: CGFloat) {
        skillTextLabel.text = skill
        cellWidth?.constant = maxWidth
        
        layoutIfNeeded()
    }
    
    private func setupUI() {
        backgroundColor = UIColor(red: 0.953, green: 0.953, blue: 0.961, alpha: 1)
        layer.cornerRadius = 12
        
        contentView.addSubview(stackView)
        
        closeButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        closeButton.isHidden = true
    }
    
    private func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        cellWidth = contentView.widthAnchor.constraint(lessThanOrEqualToConstant: 200)
        cellWidth?.isActive = true
                
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),

            closeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            closeButton.widthAnchor.constraint(equalToConstant: 14),
            closeButton.heightAnchor.constraint(equalToConstant: 14)
        ])
    }
    
    @objc private func deleteButtonTapped() {
        deleteButtonTappedHandler?()
    }
}
