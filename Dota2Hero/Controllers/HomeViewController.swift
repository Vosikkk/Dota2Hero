//
//  HomeViewController.swift
//  Dota2Hero
//
//  Created by Саша Восколович on 01.11.2023.
//

import UIKit

class HomeViewController: BaseViewController {

    private let dota2API: Dota2HeroFetcher

    private var likedObserver: NSObjectProtocol?
    
    let imageLoadQueue = OperationQueue()
    
    init(dota2API: Dota2HeroFetcher, imageFetcher: ImageFetcher, heroesStorage: HeroDataManager) {
        self.dota2API = dota2API
        super.init(heroesStorage: heroesStorage, imageFetcher: imageFetcher)
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchHeroes()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        likedObserver = NotificationCenter.default.addObserver(
            forName: .changeInAllHeroes,
            object: nil,
            queue: OperationQueue.main) { [weak self] notification in
                self?.updateTable()
            }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let observer = likedObserver {
            NotificationCenter.default.removeObserver(observer)
        }
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
                self?.heroesStorage.addAllHeroes(heroes: heroes)
                self?.updateTable()
            case .failure(let error):
                print(error)
            }
        }
    }
}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heroesStorage.allHeroes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Dota2HeroTableViewCell.identifier, for: indexPath) as? Dota2HeroTableViewCell else { return UITableViewCell() }
        
        let hero = heroesStorage.allHeroes[indexPath.row]
        cell.likeButton.setSelected(selected: hero.isLiked, animated: false)
       
        
        cell.registrationHandler = { [weak self] in
            guard let self = self else { return }
            heroesStorage.completeHero(withID: hero.heroID)
            cell.likeButton.isSelected = heroesStorage.getHero(by: hero.heroID).isLiked
        }
        
        imageLoadQueue.addOperation { [weak self] in
            guard let self = self else { return }
            imageFetcher.fetchImage(from: hero.imageURL) { result in
                switch result {
                case .success(let image):
                    if hero.heroID == hero.heroID {
                        DispatchQueue.main.async {
                            cell.configure(model: hero, with: image)
                        }
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

