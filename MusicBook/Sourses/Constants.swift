//
//  Constants.swift
//  MusicBook
//
//  Created by Александра Кострова on 03.09.2023.
//

import UIKit

enum Constants {
    
    enum Color {
        static let primaryColor = UIColor(named: "primaryColor")!
        static let blackBG = UIColor(named: "blackBG")!
        static let blackCard = UIColor(named: "blackCard")!
        
        static let textPrimary = UIColor(named: "textPrimary")!
        static let textSecondary = UIColor(named: "textSecondary")!
        static let dangerColor = UIColor(named: "dangerColor")!
    }
    
    enum Font {
        static let header = UIFont(name: "SleepLiketheDead", size: 50)
        static let primary = UIFont(name: "SleepLiketheDead", size: 25)
        static let secondary = UIFont(name: "SleepLiketheDead", size: 30)
    }
    
    enum Constraints {
        static let titleHeight = 54.0
        static let titleTopGap = 56.0
        static let universalGap = 8.0
        static let bigSideGap = 16.0
        static let bigVerticalGap = 24.0
        static let cardInsideGap = 10.0
        
        static let listContainerViewHeight = 120.0
        static let listImageWidth = 91.0
        
        static let profileContainerViewHeight = 67.0
        static let descriptionLabelWidth = 121.0
    }
    
    enum Image {
        static let sortButton = UIImage(named: "sort")
        static let addButton = UIImage(named: "add")
    }
    
    enum CornerRadius {
        static let universalRadius = 10.0
    }
}
