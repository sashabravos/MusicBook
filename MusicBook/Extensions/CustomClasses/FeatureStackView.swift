//
//  FeatureStackView.swift
//  MusicBook
//
//  Created by Александра Кострова on 03.09.2023.
//

import UIKit
import SnapKit
import CoreData

final class FeatureStackView: UIStackView {
    
    // MARK: - Labels
    
    private lazy var nameLabel = DescriptionLabel(.name)
    private lazy var surnameLabel = DescriptionLabel(.surname)
    private lazy var bDayLabel = DescriptionLabel(.bDay)
    private lazy var countyLabel = DescriptionLabel(.country)
    private lazy var genreLabel = DescriptionLabel(.genre)
    private lazy var groupLabel = DescriptionLabel(.group)
    
    
    // MARK: - TextFields
    
    lazy var nameTextField = FeatureTextField()
    lazy var surnameTextField = FeatureTextField()
    lazy var bDayTextField = FeatureTextField()
    lazy var countyTextField = FeatureTextField()
    lazy var genreTextField = FeatureTextField()
    lazy var groupTextField = FeatureTextField()
    
    // MARK: - Containers
    
    private lazy var nameContainer = makeContentView(nameLabel,
                                                     nameTextField)
    private lazy var surnameContainer = makeContentView(surnameLabel,
                                                        surnameTextField)
    private lazy var bDayContainer = makeContentView(bDayLabel,
                                                     bDayTextField)
    private lazy var countyContainer = makeContentView(countyLabel,
                                                       countyTextField)
    private lazy var genreContainer = makeContentView(genreLabel,
                                                      genreTextField)
    private lazy var groupContainer = makeContentView(groupLabel,
                                                      groupTextField)
    
    init() {
        super.init(frame: .zero)
        
        setupStackView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func makeContentView(_ leftObject: DescriptionLabel,
                                 _ rightObject: FeatureTextField) -> UIView {
        let view = UIView()
        view.layer.masksToBounds = true
        view.backgroundColor = Constants.Color.blackCard
        view.layer.cornerRadius = Constants.CornerRadius.universalRadius
        
        [leftObject, rightObject].forEach {
            view.addSubview($0)
        }
        
        view.snp.makeConstraints { make in
            make.height.equalTo(Constants.Constraints.profileContainerViewHeight)
        }
        
        leftObject.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-Constants.Constraints.cardInsideGap)
            make.leading.equalToSuperview().offset(Constants.Constraints.cardInsideGap)
            make.width.equalTo(Constants.Constraints.descriptionLabelWidth)
        }
        
        rightObject.snp.makeConstraints { make in
            make.bottom.equalTo(leftObject.snp.bottom)
            make.leading.equalTo(leftObject.snp.trailing).offset(Constants.Constraints.cardInsideGap)
            make.trailing.equalToSuperview().offset(-Constants.Constraints.cardInsideGap)
            make.height.equalTo(leftObject.snp.height)
        }
        
        return view
    }
    
    private func setupStackView() {
        self.distribution = .fillProportionally
        self.axis = .vertical
        self.spacing = Constants.Constraints.universalGap
        self.backgroundColor = Constants.Color.blackBG
        self.addArrangedSubviews([nameContainer,
                                  surnameContainer,
                                  bDayContainer,
                                  countyContainer,
                                  genreContainer,
                                  groupContainer])
    }
}
