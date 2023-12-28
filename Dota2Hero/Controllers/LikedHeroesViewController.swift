//
//  LikedHeroesViewController.swift
//  Dota2Hero
//
//  Created by Саша Восколович on 01.11.2023.
//

import UIKit


class LikedHeroesViewController: BaseViewController, Dota2HeroTableViewCellDelegate {
   
    // MARK: - Properties
       
    private let factory: Factory
    
    lazy var dataSource: DataSource = {
        
        return .init(tableView: heroesTableView) { [weak self] tableView, indexPath, item in
           
            guard let self else { return UITableViewCell() }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Dota2HeroTableViewCell.identifier, for: indexPath) as! Dota2HeroTableViewCell
            
            cell.delegate = self
            cell.likeButton.setSelected(selected: item.isLiked, animated: false)
            
            cell.registrationHandler = {
                self.heroesManager.completeHero(withID: item.heroID)
                // And here animate
                let workItem = DispatchWorkItem {
                    self.updateSnapshot(reloadOf: self.heroesManager.likedHeroes)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: workItem)
            }
            loadImage(for: item, into: cell, array: heroesManager.likedHeroes)
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateSnapshot(reloadOf: heroesManager.likedHeroes)
    }
    
    
    
    // MARK: - Initialization
    
    init(heroesManager: DataManager, fetcher: FetcherService, factory: Factory) {
        self.factory = factory
        super.init(heroesManager: heroesManager, fetcher: fetcher)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Delegate method
    
    func didTapOnImageHeroView(heroID: Int) {
        
        #if !TESTING
        let hero = heroesManager.getHero(by: heroID)
        Task {
            do {
                let image = try await fetcher.getImage(by: APIEndpoint.image(hero.img))
                let vc = HeroDetailsViewController(factory: factory, heroesManager: heroesManager)
                vc.configureUI(with: hero, and: image)
                show(vc, sender: self)
            } catch {
                print("Error occured: \(error.localizedDescription)")
            }
        }
        #endif
        let vc = HeroDetailsViewController(factory: factory, heroesManager: heroesManager)
        vc.moveSpeedLabel.text = "Test sending info to the controller"
        show(vc, sender: self)
    }
}

