//
//  LikedHeroesViewController.swift
//  Dota2Hero
//
//  Created by Саша Восколович on 01.11.2023.
//

import UIKit


class LikedHeroesViewController: BaseViewController, Dota2HeroTableViewCellDelegate {
    
    // MARK: - Properties
    
    private var likedObserver: NSObjectProtocol?
   
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
    
    init(heroesManager: DataManager, imageFetcher: ImageFetcherService, factory: Factory) {
        self.factory = factory
        super.init(heroesManager: heroesManager, imageFetcher: imageFetcher)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Delegate method
    
    func didTapOnImageHeroView(heroID: Int) {
        let hero = heroesManager.getHero(by: heroID)
        var image: UIImage?
        
        imageFetcher.fetchImage(from: APIEndpoint.image(hero.img)) { result in
            switch result {
            case .success(let img):
                image = img
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        let vc = HeroDetailsViewController(factory: factory, heroesManager: heroesManager)
        vc.configureUI(with: hero, and: image!)
        navigationController?.pushViewController(vc, animated: true)
    }
}


// MARK: UITableViewDelegate & UITableViewDataSource

extension LikedHeroesViewController: UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let size = screenSize {
            return size / 5
        }
        return 150
    }
}
