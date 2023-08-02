//
//  ViewController.swift
//  Profile | Surf Summer School 2023
//
//  Created by Ka4aH on 01.08.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    //MARK: -- Private View
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.backgroundColor = .green
        scrollView.isUserInteractionEnabled = true
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView(frame: .zero)
        contentView.backgroundColor = .red
        //        contentView.layer.backgroundColor = UIColor(red: 0.953, green: 0.953, blue: 0.961, alpha: 1).cgColor
        return contentView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "SFProDisplay-Bold", size: 16)
        return label
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.cornerRadius = 60
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 36)
        return label
    }()
    
    private let sloganLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = UIColor(red: 0.588, green: 0.584, blue: 0.608, alpha: 1)
        label.font = UIFont(name: "SFProDisplay-Regular", size: 14)
        return label
    }()
    
    private let locationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        return stackView
    }()
    
    private let locationIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "pin")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = UIColor(red: 0.588, green: 0.584, blue: 0.608, alpha: 1)
        label.font = UIFont(name: "SFProDisplay-Regular", size: 14)
        return label
    }()
    
    
    private let skillsTitleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.backgroundColor = .white
        return stackView
    }()
    
    private let skillsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Мои навыки"
        label.textColor = UIColor(red: 0.192, green: 0.192, blue: 0.192, alpha: 1)
        label.font = UIFont(name: "SFProDisplay-Medium", size: 16)
        return label
    }()
    
    private lazy var editSkillsButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "edit"), for: .normal)
        button.setImage(UIImage(named: "done"), for: .selected)
        button.addTarget(self, action: #selector(editSkillsButtonTapped), for: .touchUpInside)
        return button
    }()
    
//    private let skillsCollectionView: UICollectionView = {
//        let collectionViewLayout = UICollectionViewFlowLayout()
//        collectionViewLayout.scrollDirection = .vertical
//        collectionViewLayout.minimumLineSpacing = 8
//        collectionViewLayout.minimumInteritemSpacing = 8
//        collectionViewLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//        let collectionView = UICollectionView(frame: .null, collectionViewLayout: collectionViewLayout)
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        collectionView.backgroundColor = .blue
//        return collectionView
//    }()
    
    private lazy var skillsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
    
    private func makeLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { sectionIndex, env in
            let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(80), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(56))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.contentInsets = .init(top: 12, leading: 0, bottom: 0, trailing: 0)
            group.interItemSpacing = .fixed(12)
            
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
    }
    
    private let aboutMeTitleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.backgroundColor = .white
        return stackView
    }()
    
    private let aboutMeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "О себе"
        label.textColor = UIColor(red: 0.192, green: 0.192, blue: 0.192, alpha: 1)
        label.font = UIFont(name: "SFProDisplay-Medium", size: 16)
        return label
    }()
    
    private let aboutMeTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.192, green: 0.192, blue: 0.192, alpha: 1)
        label.font = UIFont(name: "SFProDisplay-Regular", size: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private var isEditingSkills = false
    private var presenter: ProfilePresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupConstraints()
        
        skillsCollectionView.dataSource = self
        skillsCollectionView.delegate = self
        skillsCollectionView.register(SkillCollectionViewCell.self, forCellWithReuseIdentifier: "SkillCell")
        
        presenter = ProfilePresenter(view: self)
        presenter.setView()
    }
    
    @objc private func editSkillsButtonTapped() {
        editSkillsButton.isSelected = !editSkillsButton.isSelected
        
        if isEditingSkills {
            presenter.saveSkills(getSkillsFromCollectionView())
        } else {
            presenter.didTapEditSkills()
        }
    }
}

extension ProfileViewController: ProfileView {
    func showProfile(_ profile: UserProfile) {
        titleLabel.text = profile.label
        profileImageView.image = profile.photo
        nameLabel.text = profile.name
        sloganLabel.text = profile.slogan
        locationLabel.text = profile.location
        aboutMeTextLabel.text = profile.aboutMe
        
        showEditSkillsMode(isEditingSkills)
        skillsCollectionView.reloadData()
    }
    
    func showEditSkillsMode(_ isEditing: Bool) {
        self.isEditingSkills = isEditing
        editSkillsButton.isSelected = isEditing
        skillsCollectionView.reloadData()
    }
    
    func showEditSkillAlert() {
        let alertController = UIAlertController(title: "Добавление нового навыка", message: "Введите название навыка, которым вы владеете", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Введите название"
        }
        
        let addAction = UIAlertAction(title: "Добавить", style: .default) { [weak self] _ in
            if let skillName = alertController.textFields?.first?.text, !skillName.isEmpty {
                self?.presenter.saveSkills(self?.getSkillsFromCollectionView() ?? [] + [skillName])
            }
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func reloadSkills() {
        skillsCollectionView.reloadData()
    }
}

// MARK: -- UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension ProfileViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.userProfile.skills.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SkillCell", for: indexPath) as? SkillCollectionViewCell else {
            fatalError()
        }
        
        let skill = presenter.userProfile.skills[indexPath.row]
        cell.configure(with: skill)
        
        return cell
    }

    func getSkillsFromCollectionView() -> [String] {
        let visibleCells = skillsCollectionView.visibleCells
        return visibleCells.compactMap { cell in
            if let skillLabel = cell.contentView.viewWithTag(100) as? UILabel, let skillName = skillLabel.text {
                return skillName
            }
            return nil
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isEditingSkills {
            if indexPath.item < presenter.userProfile.skills.count {
                presenter.deleteSkill(at: indexPath.item)
            } else if indexPath.item == presenter.userProfile.skills.count {
                presenter.didTapAddSkill()
            }
        }
    }
}

// MARK: - SetupUI, SetupConstraints
extension ProfileViewController {
    private func setupView() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(sloganLabel)
        contentView.addSubview(locationStackView)
        contentView.addSubview(skillsTitleStackView)
        contentView.addSubview(skillsCollectionView)
        contentView.addSubview(aboutMeTitleStackView)
        
        locationStackView.addArrangedSubview(locationIconImageView)
        locationStackView.addArrangedSubview(locationLabel)
        
        skillsTitleStackView.addArrangedSubview(skillsTitleLabel)
        skillsTitleStackView.addArrangedSubview(editSkillsButton)
        
        aboutMeTitleStackView.addArrangedSubview(aboutMeTitleLabel)
        aboutMeTitleStackView.addArrangedSubview(aboutMeTextLabel)
    }
    
    private func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        sloganLabel.translatesAutoresizingMaskIntoConstraints = false
        locationStackView.translatesAutoresizingMaskIntoConstraints = false
        skillsTitleStackView.translatesAutoresizingMaskIntoConstraints = false
        skillsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        aboutMeTitleStackView.translatesAutoresizingMaskIntoConstraints = false
        locationIconImageView.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        skillsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        editSkillsButton.translatesAutoresizingMaskIntoConstraints = false
        aboutMeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        aboutMeTextLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // ScrollView
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // ContentView
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Title Label
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            // Profile Image
            profileImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 42),
            profileImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 120),
            profileImageView.heightAnchor.constraint(equalToConstant: 120),
            
            // Name Label
            nameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 178),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Slogan Label
            sloganLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            sloganLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            sloganLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Location StackView
            locationStackView.topAnchor.constraint(equalTo: sloganLabel.bottomAnchor, constant: 8),
            locationStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            locationStackView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 16),
            locationStackView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -16),

            // Skills Title StackView
            skillsTitleStackView.topAnchor.constraint(equalTo: locationStackView.bottomAnchor, constant: 16),
            skillsTitleStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            skillsTitleStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Skills Collection View
            skillsCollectionView.topAnchor.constraint(equalTo: skillsTitleStackView.bottomAnchor, constant: 8),
            skillsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            skillsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            skillsCollectionView.heightAnchor.constraint(equalToConstant: 200),
            
            // About Me Title StackView
            aboutMeTitleStackView.topAnchor.constraint(equalTo: skillsCollectionView.bottomAnchor, constant: 24),
            aboutMeTitleStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            aboutMeTitleStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            // About Me Title Label
            aboutMeTitleLabel.leadingAnchor.constraint(equalTo: aboutMeTitleStackView.leadingAnchor),
            aboutMeTitleLabel.trailingAnchor.constraint(equalTo: aboutMeTitleStackView.trailingAnchor),

            // About Me Text Label
            aboutMeTextLabel.topAnchor.constraint(equalTo: aboutMeTitleLabel.bottomAnchor, constant: 8),
            aboutMeTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            aboutMeTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            aboutMeTextLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}
