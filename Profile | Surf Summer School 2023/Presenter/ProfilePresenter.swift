//
//  ProfilePresenter.swift
//  Profile | Surf Summer School 2023
//
//  Created by Ka4aH on 01.08.2023.
//

import Foundation
import UIKit

protocol ProfileView: AnyObject {
    func showProfile(_ profile: UserProfile)
    func showEditSkillsMode(_ isEditing: Bool)
    func showEditSkillAlert()
    func reloadSkills()
}

protocol ProfilePresenterProtocol {
    func setView()
    func didTapEditSkills()
    func didTapAddSkill()
    func deleteSkill(at index: Int)
    func saveSkills(_ skills: [String])
}

class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileView?
    var userProfile: UserProfile
    
    init(view: ProfileView) {
        self.view = view
        self.userProfile = UserProfile(label: "Профиль", photo: UIImage(named: "me") ?? UIImage(cgImage: "photo" as! CGImage), name: "Кочетков Константин Евгеньевич", slogan: "Начинающий iOS-разработчик", location: "Москва", skills: ["MVP/MVVM", "Rest API", "Xcode", "DataSource", "SOLID", "Git", "SwiftUI", "CoreData", "Lottie", "XCTests"], aboutMe: "Я недавно успешно завершил курс iOS-разработчика, который дал мне уникальную возможность окунуться в мир разработки приложений для iOS и расширить свои навыки в этой увлекательной сфере.")
    }
    
    func setView() {
        view?.showProfile(userProfile)
    }
    
    func didTapEditSkills() {
        view?.showEditSkillsMode(true)
    }
    
    func didTapAddSkill() {
        view?.showEditSkillAlert()
    }
    
    func deleteSkill(at index: Int) {
        userProfile.skills.remove(at: index)
        view?.reloadSkills()
    }
    
    func saveSkills(_ skills: [String]) {
        userProfile.skills = skills
        view?.showEditSkillsMode(false)
        view?.reloadSkills()
    }
}
