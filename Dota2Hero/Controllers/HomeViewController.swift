//
//  HomeViewController.swift
//  Dota2Hero
//
//  Created by Саша Восколович on 01.11.2023.
//

import UIKit

class HomeViewController: BaseViewController {
    
    // MARK: - Properties
    
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
    
    
    // MARK: - Helper Methods
    
    private func fetchHeroes() {
        Task {
            do {
                let heroes = try await fetcher.getHeroes(by: APIEndpoint.heroes, page: 1, pageSize: 20)
                heroesManager.allHeroes = heroes
                updateSnapshot(reloadOf: heroesManager.allHeroes)
            } catch {
                print("Error occured: \(error.localizedDescription)")
            }
        }
    }
    
    private struct Constants {
        static let pageOfFetch: Int = 1
        static let pageSizeOfFetch: Int = 15
    }
}


