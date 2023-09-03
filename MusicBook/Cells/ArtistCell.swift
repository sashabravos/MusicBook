//
//  ArtistCell.swift
//  MusicBook
//
//  Created by Александра Кострова on 03.09.2023.
//

import UIKit
import SnapKit

final class ArtistCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = "ArtistCell"
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Font.primary
        label.textAlignment = .right
        label.contentMode = .right
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        label.textColor = Constants.Color.textPrimary
        return label
    }()
    
    private lazy var surnameLabel: UILabel = {
        let label = UILabel()
        label.font = Constants.Font.secondary
        label.textAlignment = .right
        label.contentMode = .right
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        label.textColor = Constants.Color.textSecondary
        return label
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        view.backgroundColor = Constants.Color.blackCard
        view.layer.cornerRadius = Constants.CornerRadius.universalRadius
        
        [nameLabel, surnameLabel].forEach {
            view.addSubview($0)
        }
        return view
    }()
    
    // MARK: - Initialisers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func setupCell() {
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.layer.cornerRadius = Constants.CornerRadius.universalRadius
        self.selectionStyle = .none
        self.backgroundColor = Constants.Color.blackBG
        self.addSubview(containerView)
    }
    
    private func setupViews() {
        containerView.snp.makeConstraints{ make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(Constants.Constraints.listContainerViewHeight)
            make.bottom.equalToSuperview().offset(-Constants.Constraints.universalGap)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-Constants.Constraints.universalGap)
            make.leading.equalToSuperview().offset(Constants.Constraints.cardInsideGap)
        }
        
        surnameLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(Constants.Constraints.cardInsideGap)
            make.leading.equalTo(nameLabel.snp.leading)
        }
    }
    
    // MARK: - Public Methods
    
    public func configure(with artist: Artist) {
        
        nameLabel.text = artist.name
        surnameLabel.text = artist.surname
    }
}
