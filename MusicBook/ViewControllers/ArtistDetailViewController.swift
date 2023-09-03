//
//  ArtistDetailViewController.swift
//  MusicBook
//
//  Created by Александра Кострова on 03.09.2023.
//

import UIKit
import SnapKit
import CoreData

// MARK: - ArtistDetailDelegate

protocol ArtistDetailDelegate: AnyObject {
    func updateWithData(_ controller: ArtistDetailViewController,
                        didSaveArtist artistModel: ArtistModel,
                        indexPath: IndexPath)
    
    func addNewArtist(_ controller: ArtistDetailViewController,
                          didSaveArtist artistModel: ArtistModel,
                          with newArtist: Artist?)
}

final class ArtistDetailViewController: UIViewController {
    
    // MARK: - Instants
    
    weak var delegate: ArtistDetailDelegate?
    
    var artist: Artist? {
        didSet {
            updateArtistData(artist: artist)
        }
    }
    var currentCell = IndexPath()
    private var fetchedResultsController: NSFetchedResultsController<Artist>!
    private let fetchRequest: NSFetchRequest <Artist> = Artist.fetchRequest()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: - UI Elements
    
    private lazy var headerLabel: HeaderLabel = {
        let label = HeaderLabel(name: .profile)
        return label
    }()
    
    private lazy var saveButton = makeVariableButton(with: "Save",
                                                     textColor: Constants.Color.textSecondary)
    private lazy var closeButton = makeVariableButton(with: "Close",
                                                      textColor: Constants.Color.dangerColor)
    
    lazy var featureStackView = FeatureStackView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegates()
        addGesture()
        setupSubviews()
        setupLayout()
    }
    
    // MARK: - Actions
    
    @objc private func buttonTapped(_ sender: UIButton) {

        if sender == saveButton {
            
            let artistModel = ArtistModel (
                name: featureStackView.nameTextField.text ?? "",
                surname: featureStackView.surnameTextField.text  ?? "",
                bDay: featureStackView.bDayTextField.text  ?? "",
                country: featureStackView.countyTextField.text  ?? "",
                genre: featureStackView.genreTextField.text  ?? "",
                group: featureStackView.groupTextField.text  ?? ""
            )
            
            if artist == nil {
                let newArtist = Artist(context: context)
                delegate?.addNewArtist(self,
                                       didSaveArtist: artistModel,
                                       with: newArtist)
            } else {
                
                delegate?.updateWithData(self,
                                         didSaveArtist: artistModel,
                                         indexPath: currentCell)
            }
        }
                
        do {
            try context.save()
        } catch {
            print("Can't update info: \(error)")
        }
        
        self.dismiss(animated: true)
    }
    
    
    
    // MARK: - Data work
    
    private func updateArtistData(artist: Artist?) {
        
        if let artist = artist {
            
            featureStackView.nameTextField.text = artist.name
            featureStackView.surnameTextField.text = artist.surname
            featureStackView.bDayTextField.text = artist.bDay
            featureStackView.countyTextField.text = artist.country
            featureStackView.genreTextField.text = artist.genre
            featureStackView.groupTextField.text = artist.group
            
        }
    }
    
    
    // MARK: - Creating elements
    
    private func makeVariableButton(with name: String,
                                    textColor: UIColor) -> UIButton {
        let button = UIButton()
        button.setTitle(name, for: .normal)
        button.contentMode = .topRight
        button.titleLabel?.textAlignment = .right
        button.titleLabel?.font = Constants.Font.secondary
        button.setTitleColor(textColor, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }
    
    
    // MARK: - Setting items
    
    private func setDelegates() {
        
        [featureStackView.bDayTextField,
         featureStackView.countyTextField,
         featureStackView.genreTextField,
         featureStackView.groupTextField,
         featureStackView.nameTextField,
         featureStackView.surnameTextField].forEach {
            $0.delegate = self
        }
    }
    
    private func setupSubviews() {
        view.backgroundColor = Constants.Color.blackBG
        
        [headerLabel, closeButton, saveButton, featureStackView].forEach {
            view.addSubview($0)
        }
    }
    
    private func setupLayout() {
        
        
        closeButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.Constraints.bigSideGap)
            make.top.equalToSuperview().offset(Constants.Constraints.universalGap)
        }
        
        saveButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-Constants.Constraints.bigSideGap)
            make.top.equalTo(closeButton.snp.top)
        }
        
        headerLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.Constraints.bigSideGap)
            make.trailing.equalTo(saveButton.snp.leading).offset(Constants.Constraints.universalGap)
            make.height.equalTo(Constants.Constraints.titleHeight)
            make.top.equalToSuperview().offset(Constants.Constraints.titleTopGap)
        }
        
        featureStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.Constraints.universalGap)
            make.trailing.equalToSuperview().offset(-Constants.Constraints.universalGap)
            make.top.equalTo(headerLabel.snp.bottom).offset(Constants.Constraints.universalGap)
        }
    }
}


// MARK: - UITextFieldDelegate

extension ArtistDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - UITapGestureRecognizer
    
    private func addGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
}
