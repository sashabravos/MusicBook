//
//  HeaderLabel.swift
//  MusicBook
//
//  Created by Александра Кострова on 03.09.2023.
//

import UIKit

final class HeaderLabel: UILabel {
    
    var name: Title
    
    enum Title {
        case artistsList, profile
    }
    
    init(name: Title) {
        self.name = name
        super.init(frame: .zero)
        
        self.font = Constants.Font.header
        self.numberOfLines = 1
        self.contentMode = .bottomLeft
        self.minimumScaleFactor = 0.5
        self.adjustsFontSizeToFitWidth = true
        self.textColor = Constants.Color.primaryColor
        
        switch name {
        case .artistsList:
            text = "Artist list"
        case .profile:
            text = "Profile"
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
