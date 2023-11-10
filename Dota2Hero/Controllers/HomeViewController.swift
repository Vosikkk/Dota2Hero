//
//  HomeViewController.swift
//  Dota2Hero
//
//  Created by Саша Восколович on 01.11.2023.
//

import UIKit

class HomeViewController: BaseViewController {

    private let dota2API: Dota2HeroFetcher
    private let imageLoadQueue = OperationQueue()
    private var operations: [IndexPath: Operation] = [:]
    
    init(dota2API: Dota2HeroFetcher, imageFetcher: ImageFetcher, heroesStorage: TemporaryStorageForHeroes) {
        self.dota2API = dota2API
        super.init(heroesStorage: heroesStorage, imageFetcher: imageFetcher)
       
        heroesStorage.allHeroesChangedHandler = { [weak self] hero in
            if let index = self?.heroes.firstIndex(where: { $0.heroID == hero.heroID } ) {
                self?.heroes[index].isLiked = hero.isLiked
            }
        }
    }
    
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchHeroes()
    }
    
    override func setupUI() {
        super.setupUI()
        heroesTableView.delegate = self
        heroesTableView.dataSource = self
    }
    
    private func fetchHeroes() {
        dota2API.fetch(page: 1, pageSize: 11) { [weak self] result in
            switch result {
            case .success(let heroes):
                self?.heroes = heroes
                self?.heroesStorage.addAllHeroes(heroes: heroes)
            case .failure(let error):
                print(error)
            }
        }
    }
}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heroes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Dota2HeroTableViewCell.identifier, for: indexPath) as? Dota2HeroTableViewCell else { return UITableViewCell() }
        
        cell.likeButton.isSelected = heroes[indexPath.row].isLiked
        
        cell.registrationHandler = { [weak self] in
            guard let self = self, heroes.indices.contains(indexPath.row) else { return }
            
            let isLiked = !self.heroes[indexPath.row].isLiked
            self.heroes[indexPath.row].isLiked = isLiked
            
            let hero = self.heroes[indexPath.row]
            
            if isLiked {
                self.heroesStorage.addLiked(hero: hero)
            } else {
                self.heroesStorage.removeLiked(hero: hero)
            }
        }
        
        let loadOperation = BlockOperation { [weak self] in
            guard let self = self else { return }
            imageFetcher.fetchImage(from: heroes[indexPath.row].imageURL) { result in
                
                switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        cell.configure(model: self.heroes[indexPath.row], with: image)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            self.operations.removeValue(forKey: indexPath)
        }
        operations[indexPath] = loadOperation
        imageLoadQueue.addOperation(loadOperation)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let size = screenSize, UIDevice.current.orientation.isPortrait {
            return size / 5
        }
        return 150
    }
}

