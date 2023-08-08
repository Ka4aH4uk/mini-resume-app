//
//  AddSkillCollectionViewCell.swift
//  Profile | Surf Summer School 2023
//
//  Created by Ka4aH on 08.08.2023.
//

import UIKit

class AddSkillCollectionViewCell: UICollectionViewCell {
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .black
        button.setTitle("+", for: .normal)
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()

    var addButtonTappedHandler: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setup() {
        backgroundColor = UIColor(red: 0.953, green: 0.953, blue: 0.961, alpha: 1)
        layer.cornerRadius = 10
        
        contentView.addSubview(addButton)
        
        addButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            addButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            addButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            addButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            addButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
        ])
    }

    @objc private func addButtonTapped() {
        addButtonTappedHandler?()
    }
}
