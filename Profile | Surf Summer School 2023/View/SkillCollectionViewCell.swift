//
//  SkillCollectionViewCell.swift
//  Profile | Surf Summer School 2023
//
//  Created by Ka4aH on 01.08.2023.
//

import Foundation
import UIKit

class SkillCollectionViewCell: UICollectionViewCell {
    let skillLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let deleteIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "multiply")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        return imageView
    }()
    
    let plusIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "plus") 
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(with skill: String) {
            skillLabel.text = skill
        }

    private func setup() {
        backgroundColor = UIColor(red: 0.953, green: 0.953, blue: 0.961, alpha: 1)
        layer.cornerRadius = 10
        
        contentView.addSubview(skillLabel)
        contentView.addSubview(deleteIconImageView)
        contentView.addSubview(plusIconImageView)
        
        NSLayoutConstraint.activate([
            skillLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            skillLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            skillLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            skillLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
//            deleteIconImageView.leadingAnchor.constraint(equalTo: skillLabel.trailingAnchor, constant: 5),
//            deleteIconImageView.topAnchor.constraint(equalTo: skillLabel.topAnchor)
//            plusIconImageView
        ])
    }
}
