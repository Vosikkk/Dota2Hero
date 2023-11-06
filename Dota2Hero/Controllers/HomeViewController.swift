//
//  HomeViewController.swift
//  Dota2Hero
//
//  Created by Саша Восколович on 01.11.2023.
//

import UIKit

class HomeViewController: UIViewController {

    private let dota2API: Dota2HeroFetcher
    private let imageFetcher: ImageFetcher
    private let heroesStorage: TemporaryStorageForHeroes
    
    
   
    private let dota2HeroesTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(Dota2HeroTableViewCell.self, forCellReuseIdentifier: Dota2HeroTableViewCell.identifier)
        return tableView
    }()
    
    private var screenSize: CGFloat? {
       return UIScreen.current?.bounds.height
    }
    
    private var heroes: Heroes = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.dota2HeroesTableView.reloadData()
            }
        }
    }
    
    
    private var likedStates: [Int: Bool] = [:]
    
    
    init(dota2API: Dota2HeroFetcher, imageFetcher: ImageFetcher, heroesStorage: TemporaryStorageForHeroes) {
        self.dota2API = dota2API
        self.imageFetcher = imageFetcher
        self.heroesStorage = heroesStorage
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetch()
    }
    
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(dota2HeroesTableView)
        
        configureNavigationBarWithLogo()
        
        dota2HeroesTableView.allowsSelection = false
        dota2HeroesTableView.delegate = self
        dota2HeroesTableView.dataSource = self
        
    }
    
    
    
    private func fetch() {
        dota2API.fetch(page: 1, pageSize: 11) { [weak self] result in
            switch result {
            case .success(let heroes):
                self?.heroes = heroes
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
           super.viewDidLayoutSubviews()
           dota2HeroesTableView.frame = view.frame
       }
}



extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heroes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Dota2HeroTableViewCell.identifier, for: indexPath) as? Dota2HeroTableViewCell else { return UITableViewCell() }
        var model = heroes[indexPath.row]
        cell.likeButton.isSelected = model.isLiked
        
        cell.registrationHandler = { [weak self] in
            let isLiked = !model.isLiked
            model.isLiked = isLiked
            if isLiked {
                self?.heroesStorage.addLiked(hero: model)
            } else {
                self?.heroesStorage.changeModel(by: model.heroID)
                self?.heroesStorage.removeLikedHero()
            }
            cell.likeButton.isSelected = isLiked
        }
        
        imageFetcher.fetchImage(from: model.imageURL) { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    cell.configure(model: model, with: image)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let size = screenSize, UIDevice.current.orientation.isPortrait {
            return size / 5
        }
        return 150
    }
}

