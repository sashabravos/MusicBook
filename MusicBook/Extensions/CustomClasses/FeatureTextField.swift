//
//  FeatureTextField.swift
//  MusicBook
//
//  Created by Александра Кострова on 03.09.2023.
//

import UIKit

final class FeatureTextField: UITextField {
    
    init() {
        super.init(frame: .zero)
        
        self.font = Constants.Font.secondary
        self.textAlignment = .right
        self.contentMode = .bottomRight
        self.placeholder = "TAP HERE"
        self.returnKeyType = .done
        self.adjustsFontSizeToFitWidth = true
        self.textColor = Constants.Color.textPrimary
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
