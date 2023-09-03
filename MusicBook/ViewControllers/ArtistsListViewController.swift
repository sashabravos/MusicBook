//
//  ArtistsListViewController.swift
//  MusicBook
//
//  Created by Александра Кострова on 03.09.2023.
//

import UIKit
import SnapKit
import CoreData

final class ArtistsListViewController: UIViewController {
    
    // MARK: - Instants
    
    private var fetchedResultsController: NSFetchedResultsController<Artist>!
    private let fetchRequest: NSFetchRequest <Artist> = Artist.fetchRequest()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private lazy var currentSortingType: SortingType = .alphabetically
    
    // MARK: - UI Elements
    
    private lazy var headerLabel: HeaderLabel = {
        let label = HeaderLabel(name: .artistsList)
        return label
    }()
    
    private lazy var sortButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.Image.sortButton, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setImage(Constants.Image.addButton, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = Constants.Color.blackBG
        tableView.register(ArtistCell.self, forCellReuseIdentifier: ArtistCell.identifier)
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFetchedResultsController()
        setupSubviews()
        setupLayout()
    }
    
    
    // MARK: - Private Methods
    
    @objc private func buttonTapped(sender: UIButton) {
        if sender == sortButton {
            changeSort()
        } else {
        }
    }
    
    private func setupSubviews() {
        tableView.dataSource = self
        tableView.delegate = self
        
        view.backgroundColor = Constants.Color.blackBG
        
        [headerLabel, sortButton, addButton, tableView].forEach {
            view.addSubview($0)
        }
    }
    
    private func setupLayout() {
        headerLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.Constraints.bigSideGap)
            make.trailing.equalTo(sortButton.snp.leading).offset(-Constants.Constraints.universalGap)
            make.height.equalTo(Constants.Constraints.titleHeight)
            make.top.equalToSuperview().offset(Constants.Constraints.titleTopGap)
        }
        
        sortButton.snp.makeConstraints { make in
            make.height.width.equalTo(headerLabel.snp.height)
            make.trailing.equalTo(addButton.snp.leading).offset(-Constants.Constraints.universalGap)
            make.top.equalTo(headerLabel.snp.top)
        }
        
        addButton.snp.makeConstraints { make in
            make.top.equalTo(headerLabel.snp.top)
            make.height.width.equalTo(headerLabel.snp.height)
            make.trailing.equalToSuperview().offset(-Constants.Constraints.bigSideGap)
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Constants.Constraints.universalGap)
            make.trailing.equalToSuperview().offset(-Constants.Constraints.universalGap)
            make.top.equalTo(headerLabel.snp.bottom).offset(Constants.Constraints.bigVerticalGap)
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - Sorting methods

extension ArtistsListViewController {
    
    private func setupFetchedResultsController() {
        let sortDescriptor = NSSortDescriptor(key: "surname", ascending: currentSortingType == .alphabetically)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        do {
            try fetchedResultsController.performFetch()
            fetchedResultsController.delegate = self
        } catch {
            print("Error fetching data: \(error)")
        }
    }
    
    private func changeSort() {
        currentSortingType = (currentSortingType == .alphabetically) ? .reverse : .alphabetically
        saveSortingType()
        
        setupFetchedResultsController()
        tableView.reloadData()
    }
    
    private func saveSortingType() {
        if let savedSortingTypeString = UserDefaults.standard.string(forKey: "SortingType"),
           let savedSortingType = SortingType(rawValue: savedSortingTypeString) {
            currentSortingType = savedSortingType
        }
    }
    
    private enum SortingType: String {
        case alphabetically
        case reverse
    }
}

// MARK: - UITableViewDelegate

extension ArtistsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ArtistCell.identifier, for: indexPath) as! ArtistCell
        let artist = fetchedResultsController.object(at: indexPath)
        cell.configure(with: artist)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

// MARK: - UITableViewDataSource

extension ArtistsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "") { [weak self] (_, _, completionHandler) in
            guard let self = self else { return }
            
            let artist = self.fetchedResultsController.object(at: indexPath)
            
            self.context.delete(artist)
            do {
                try self.context.save()
            } catch {
                print("Error deleting artist: \(error)")
            }
            completionHandler(true)
        }
        
        
        deleteAction.image = UIImage(systemName: "trash")?.withTintColor(Constants.Color.textPrimary)
        deleteAction.backgroundColor = Constants.Color.dangerColor
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension ArtistsListViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
            
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        case .move:
            if let indexPath = indexPath, let newIndexPath = newIndexPath {
                tableView.moveRow(at: indexPath, to: newIndexPath)
            }
        @unknown default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
