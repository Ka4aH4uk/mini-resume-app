//
//  ProfileModel.swift
//  Profile | Surf Summer School 2023
//
//  Created by Ka4aH on 01.08.2023.
//

import Foundation
import UIKit

struct UserProfile {
    let label: String
    let photo: UIImage
    let name: String
    let slogan: String
    let location: String
    var skills: [String]
    let aboutMe: String
    
    var isEditingSkills: Bool = false
}
