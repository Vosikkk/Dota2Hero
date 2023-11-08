//
//  LikedHeroesViewController.swift
//  Dota2Hero
//
//  Created by Саша Восколович on 01.11.2023.
//

import UIKit

class LikedHeroesViewController: BaseViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
   override init(heroesStorage: TemporaryStorageForHeroes, imageFetcher: ImageFetcher) {
        super.init(heroesStorage: heroesStorage, imageFetcher: imageFetcher)
       
       heroesStorage.likedHeroesDidChangeHandler = { [weak self] in
            self?.heroes = heroesStorage.getLikedHeroes()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupUI() {
        super.setupUI()
        heroesTableView.delegate = self
        heroesTableView.dataSource = self
    }
}


extension LikedHeroesViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heroes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Dota2HeroTableViewCell.identifier, for: indexPath) as? Dota2HeroTableViewCell else { return UITableViewCell() }
    
           
        cell.likeButton.isSelected = heroes[indexPath.row].isLiked
       
        cell.registrationHandler = { [weak self] in
            guard let self = self, heroes.indices.contains(indexPath.row) else { return }
            
            let heroID = self.heroes[indexPath.row].heroID
            
            tableView.performBatchUpdates {
                self.heroes.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
            } completion: { finished in
                self.heroesStorage.removeLikedHero(by: heroID)
                self.heroesStorage.changeSimpleModels(by: heroID)
            }
        }
        
        imageFetcher.fetchImage(from: heroes[indexPath.row].imageURL) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    cell.configure(model: self.heroes[indexPath.row], with: image)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
