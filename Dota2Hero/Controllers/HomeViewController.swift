//
//  HomeViewController.swift
//  Dota2Hero
//
//  Created by Саша Восколович on 01.11.2023.
//

import UIKit

class HomeViewController: BaseViewController {
   
    // MARK: - Properties
    
    private let dota2API: APIManager
    
    // MARK: - Initialization
    
    init(dota2API: APIManager, imageFetcher: ImageFetcherService, heroesManager: DataManager) {
        self.dota2API = dota2API
        super.init(heroesManager: heroesManager, imageFetcher: imageFetcher)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updaterHandler = { [weak self] snapshot in
            DispatchQueue.main.async {
                self?.dataSource.apply(snapshot, animatingDifferences: false)
            }
        }
        fetchHeroes()
    }
  

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        heroesTableView.reloadData()
        updateSnapshot(reloadOf: heroesManager.allHeroes)
        
    }
    
    
    
    lazy var dataSource: DataSource = {
        return .init(tableView: heroesTableView) { [weak self] tableView, indexPath, item in
            guard let self else { return UITableViewCell() }
            let cell = tableView.dequeueReusableCell(withIdentifier: Dota2HeroTableViewCell.identifier, for: indexPath) as! Dota2HeroTableViewCell
            
            cell.likeButton.setSelected(selected: item.isLiked, animated: false)
            
            cell.registrationHandler = {
                self.heroesManager.completeHero(withID: item.heroID)
                // And here animate
                cell.likeButton.isSelected = self.heroesManager.getHero(by: item.heroID).isLiked
            }
            loadImage(for: item, into: cell, array: heroesManager.allHeroes)
            return cell
        }
    }()
    
    // MARK: - Helper Methods
    
    private func fetchHeroes() {
        dota2API.fetch(APIEndpoint.heroes, page: Constants.pageOfFetch, pageSize: Constants.pageSizeOfFetch) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let heroes):
                heroesManager.allHeroes = heroes
                updateSnapshot(reloadOf: heroesManager.allHeroes)
            case .failure(let error):
                print(error)
            }
        }
    }
   
    private struct Constants {
        static let pageOfFetch: Int = 1
        static let pageSizeOfFetch: Int = 15
    }
}

// MARK: UITableViewDelegate & UITableViewDataSource

extension HomeViewController: UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let size = screenSize {
            return size / 5
        }
        return 150
    }
}

