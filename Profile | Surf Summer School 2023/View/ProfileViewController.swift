//
//  ViewController.swift
//  Profile | Surf Summer School 2023
//
//  Created by Ka4aH on 01.08.2023.
//
// The application contains the functionality of a mini-resume, the “My Skills” block is editable, the rest is hardcode. The screen can scroll. Development should be carried out on UIKit without third-party libraries, only by native means.


import UIKit

final class ProfileViewController: UIViewController {
    //MARK: -- Private Properties
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.isUserInteractionEnabled = true
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView(frame: .zero)
        contentView.backgroundColor = .white
        return contentView
    }()
    
    private lazy var backView: UIView = {
        let backView = UIView(frame: .zero)
        backView.layer.backgroundColor = UIColor(red: 0.953, green: 0.953, blue: 0.961, alpha: 1).cgColor
        return backView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .sfproBold(size: 16)
        return label
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.cornerRadius = 60
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = .sfproBold(size: 24)
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var sloganLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = UIColor(red: 0.588, green: 0.584, blue: 0.608, alpha: 1)
        label.font = .sfproRegular(size: 14)
        return label
    }()
    
    private lazy var locationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var locationIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "pin")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = UIColor(red: 0.588, green: 0.584, blue: 0.608, alpha: 1)
        label.font = .sfproRegular(size: 14)
        return label
    }()
    
    
    private lazy var skillsTitleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var skillsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Мои навыки"
        label.textColor = UIColor(red: 0.192, green: 0.192, blue: 0.192, alpha: 1)
        label.font = .sfproMedium(size: 16)
        return label
    }()
    
    private lazy var editSkillsButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "edit"), for: .normal)
        button.setImage(UIImage(named: "done"), for: .selected)
        button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var skillsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: makeLayout())
    
    private lazy var aboutMeTitleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var aboutMeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "О себе"
        label.textColor = UIColor(red: 0.192, green: 0.192, blue: 0.192, alpha: 1)
        label.font = .sfproMedium(size: 16)
        return label
    }()
    
    private lazy var aboutMeTextLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.192, green: 0.192, blue: 0.192, alpha: 1)
        label.font = .sfproRegular(size: 14)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var addSkillAlertController: UIAlertController = {
        let alertController = UIAlertController(title: "Добавление навыка", message: "Введите название навыка, которым вы владеете", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Введите название"
        }
        
        let addAction = UIAlertAction(title: "Добавить", style: .default) { [weak self] _ in
            if let skillName = alertController.textFields?.first?.text, !skillName.isEmpty {
                self?.presenter?.saveSkills(self?.getSkillsFromCollectionView() ?? [] + [skillName])
            }
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        return alertController
    }()
    
    private lazy var skillsCollectionViewHeightConstraint: NSLayoutConstraint = {
        return skillsCollectionView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height)
    }()
    
    private var isEditingSkills = false
    private var showAddSkillCell = false
    private var presenter: ProfilePresenter?
    
    //MARK: -- Life Cycles Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupConstraints()
        
        skillsCollectionView.dataSource = self
        skillsCollectionView.delegate = self
        skillsCollectionView.register(SkillCollectionViewCell.self, forCellWithReuseIdentifier: "SkillCell")
        skillsCollectionView.register(AddSkillCollectionViewCell.self, forCellWithReuseIdentifier: "AddSkillCell")
        skillsCollectionView.isScrollEnabled = false
        skillsCollectionView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
        presenter = ProfilePresenter(view: self)
        presenter?.setView()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize", object as AnyObject? === skillsCollectionView {
            let newHeight = skillsCollectionView.collectionViewLayout.collectionViewContentSize.height
            skillsCollectionViewHeightConstraint.constant = newHeight + 20
            contentView.layoutIfNeeded()
        }
    }
    
    deinit {
        skillsCollectionView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    //MARK: -- Private Methods
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
    
    @objc private func editButtonTapped() {
        isEditingSkills.toggle()
        showAddSkillCell = isEditingSkills
        showEditSkillsMode(isEditingSkills)
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
    }
    
    func showEditSkillsMode(_ isEditing: Bool) {
        self.isEditingSkills = isEditing
        editSkillsButton.isSelected = isEditing
        skillsCollectionView.reloadData()
    }
    
    func showEditSkillAlert(completion: @escaping (String?) -> Void) {
        present(addSkillAlertController, animated: true, completion: nil)
    }
    
    func reloadSkills() {
        skillsCollectionView.reloadData()
    }
}

// MARK: -- UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension ProfileViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (presenter?.userProfile.skills.count ?? 0) + (showAddSkillCell ? 1 : 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == presenter?.userProfile.skills.count && showAddSkillCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddSkillCell", for: indexPath) as! AddSkillCollectionViewCell
            
            cell.addButtonTappedHandler = { [weak self] in
                self?.presenter?.didTapAddSkill()
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SkillCell", for: indexPath) as! SkillCollectionViewCell
            
            let skill = presenter?.userProfile.skills[indexPath.row]
            cell.configure(with: skill ?? "")
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isEditingSkills {
            if indexPath.item < presenter?.userProfile.skills.count ?? 0 {
                presenter?.deleteSkill(at: indexPath.item)
            }
        }
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
}

// MARK: - SetupUI, SetupConstraints
extension ProfileViewController {
    private func setupView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(backView)
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
        backView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        sloganLabel.translatesAutoresizingMaskIntoConstraints = false
        locationStackView.translatesAutoresizingMaskIntoConstraints = false
        locationIconImageView.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        skillsTitleStackView.translatesAutoresizingMaskIntoConstraints = false
        skillsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        editSkillsButton.translatesAutoresizingMaskIntoConstraints = false
        skillsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        aboutMeTitleStackView.translatesAutoresizingMaskIntoConstraints = false
        aboutMeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        aboutMeTextLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // scrollView
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // contentView
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // backView
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backView.heightAnchor.constraint(equalToConstant: 330)
        ])
        
        // titleLabel
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 18)
        ])
        
        // profileImageView
        NSLayoutConstraint.activate([
            profileImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            profileImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            profileImageView.widthAnchor.constraint(equalToConstant: 120),
            profileImageView.heightAnchor.constraint(equalToConstant: 120)
        ])
        
        // nameLabel
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
        
        // sloganLabel
        NSLayoutConstraint.activate([
            sloganLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            sloganLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            sloganLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            sloganLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        // locationStackView (horizontal) with locationIconImageView and locationLabel
        NSLayoutConstraint.activate([
            locationStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            locationStackView.topAnchor.constraint(equalTo: sloganLabel.bottomAnchor, constant: 4),
            locationIconImageView.widthAnchor.constraint(equalToConstant: 16),
            locationIconImageView.heightAnchor.constraint(equalToConstant: 16)
        ])
        
        // skillsTitleStackView (horizontal) with skillsTitleLabel and editSkillsButton
        NSLayoutConstraint.activate([
            skillsTitleStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            skillsTitleStackView.topAnchor.constraint(equalTo: locationStackView.bottomAnchor, constant: 40),
            skillsTitleStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            skillsTitleStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        // editSkillsButton
        NSLayoutConstraint.activate([
            editSkillsButton.widthAnchor.constraint(equalToConstant: 24),
            editSkillsButton.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        // skillsCollectionView
        NSLayoutConstraint.activate([
            skillsCollectionView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            skillsCollectionView.topAnchor.constraint(equalTo: skillsTitleStackView.bottomAnchor, constant: 8),
            skillsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            skillsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            skillsCollectionViewHeightConstraint
        ])
        
        // aboutMeTitleStackView (vertical) with aboutMeTitleLabel and aboutMeTextLabel
        NSLayoutConstraint.activate([
            aboutMeTitleStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            aboutMeTitleStackView.topAnchor.constraint(equalTo: skillsCollectionView.bottomAnchor, constant: 24),
            aboutMeTitleStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            aboutMeTitleStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            aboutMeTitleStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}
