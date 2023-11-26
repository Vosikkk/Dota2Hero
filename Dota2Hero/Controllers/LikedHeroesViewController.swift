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
    
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    // MARK: - Initialization
    
    init(heroesManager: DataManager, imageFetcher: ImageFetcherService, factory: Factory) {
        self.factory = factory
        super.init(heroesManager: heroesManager, imageFetcher: imageFetcher)
        
        // Listen to your heart
        likedObserver = NotificationCenter.default.addObserver(
            forName: .changeLikeDislike,
            object: nil,
            queue: OperationQueue.main) { [weak self] notification in
                self?.updateTable()
            }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    deinit {
        if let observer = likedObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    // MARK: - Helper Method
    
    override func setupUI() {
        super.setupUI()
        heroesTableView.delegate = self
        heroesTableView.dataSource = self
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

extension LikedHeroesViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heroesManager.likedHeroes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Dota2HeroTableViewCell.identifier, for: indexPath) as? Dota2HeroTableViewCell else { return UITableViewCell() }
    
        cell.delegate = self
        
        let hero = heroesManager.likedHeroes[indexPath.row]
        cell.likeButton.setSelected(selected: hero.isLiked, animated: false)
        
        cell.registrationHandler = { [weak self] in
            guard let self else { return }
            
            tableView.performBatchUpdates {
                self.heroesManager.completeHero(withID: hero.heroID)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
            } completion: { finished in
               
            }
        }
        
        imageFetcher.fetchImage(from: APIEndpoint.image(hero.img)) { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    cell.configure(model: hero, with: image)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let size = screenSize {
            return size / 5
        }
        return 150
    }
}
