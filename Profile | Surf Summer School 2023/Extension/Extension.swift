//
//  Extension.swift
//  Profile | Surf Summer School 2023
//
//  Created by Ka4aH on 01.08.2023.
//

import Foundation
import UIKit

extension UIFont {
    static func sfproBold(size: CGFloat) -> UIFont? {
        return UIFont(name: "SFProDisplay-Bold", size: size)
    }
    
    static func sfproMedium(size: CGFloat) -> UIFont? {
        return UIFont(name: "SFProDisplay-Medium", size: size)
    }
    
    static func sfproRegular(size: CGFloat) -> UIFont? {
        return UIFont(name: "SFProDisplay-Regular", size: size)
    }
}

extension UIColor {
    static let myDarkGrey = UIColor(red: 0.192, green: 0.192, blue: 0.192, alpha: 1)
    
    static let myLightGrey = UIColor(red: 0.588, green: 0.584, blue: 0.608, alpha: 1)

    static let backGrey = UIColor(red: 0.953, green: 0.953, blue: 0.961, alpha: 1)
}
