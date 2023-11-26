//
//  HomeViewController.swift
//  Dota2Hero
//
//  Created by Саша Восколович on 01.11.2023.
//

import UIKit

class HomeViewController: BaseViewController {
   
    

    //MARK: - Properties
    
    private let dota2API: APIManager

    private var likedObserver: NSObjectProtocol?
    
    private let imageLoadQueue = OperationQueue()
    
    
    // MARK: - Initialization
    
    init(dota2API: APIManager, imageFetcher: ImageFetcherService, heroesManager: HeroInteractionHandler) {
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
        fetchHeroes()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // We are not on the controller, so we have to listen, what user changing on other controllers
        // So we need to reload our table
        
        likedObserver = NotificationCenter.default.addObserver(
            forName: .changeLikeDislike,
            object: nil,
            queue: OperationQueue.main) { [weak self] notification in
                self?.updateTable()
            }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // And when we are on the controller, observer become useless, we don't need reload our table every tap
        if let observer = likedObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    // MARK: - Helper Methods
    
    
    override func setupUI() {
        super.setupUI()
        heroesTableView.delegate = self
        heroesTableView.dataSource = self
    }
   
    private func fetchHeroes() {
        dota2API.fetch(APIEndpoint.heroes, page: Constants.pageOfFetch, pageSize: Constants.pageSizeOfFetch) { [weak self] result in
            switch result {
            case .success(let heroes):
                if let heroesmanager = self?.heroesManager as? HeroesDataStorageManager {
                    heroesmanager.add(heroes)
                }
                self?.updateTable()
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

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
   
   
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heroesManager.getAmountOfAll()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Dota2HeroTableViewCell.identifier, for: indexPath) as? Dota2HeroTableViewCell else { return UITableViewCell() }
        
        let hero = heroesManager.getInAll(by: indexPath)
     
        // Just make our button red without animation
        cell.likeButton.setSelected(selected: hero.isLiked, animated: false)
       
      
        cell.registrationHandler = { [weak self] in
            guard let self else { return }
            heroesManager.completeHero(withID: hero.heroID)
            
            // And here animate
            cell.likeButton.isSelected = heroesManager.getInAll(by: hero.heroID).isLiked
        }
        
        imageLoadQueue.addOperation { [weak self] in
            guard let self else { return }
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

