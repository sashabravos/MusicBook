//
//  DescriptionLabel.swift
//  MusicBook
//
//  Created by Александра Кострова on 03.09.2023.
//

import UIKit

final class DescriptionLabel: UILabel {
        
    var name: LabelNames
    
    enum LabelNames {
        case name, surname, bDay, country, genre, group
    }
    
    init(_ name: LabelNames) {
        self.name = name
        super.init(frame: .zero)
        
        self.font = Constants.Font.secondary
        self.numberOfLines = 1
        self.textAlignment = .left
        self.contentMode = .bottomLeft
        self.minimumScaleFactor = 0.5
        self.adjustsFontSizeToFitWidth = true
        self.textColor = Constants.Color.textPrimary
        
        switch name {
        case .name:
            self.text = "Name:"
        case .surname:
            self.text = "Surname:"
        case .bDay:
            self.text = "B-Day:"
        case .country:
            self.text = "Country:"
        case .genre:
            self.text = "Genre:"
        case .group:
            self.text = "Group:"
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

