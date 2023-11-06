//
//  LikedHeroesViewController.swift
//  Dota2Hero
//
//  Created by Саша Восколович on 01.11.2023.
//

import UIKit

class LikedHeroesViewController: UIViewController {

    
    private let heroesStorage: TemporaryStorageForHeroes
    private let imageFetcher: ImageFetcher
    
    
    private lazy var likedHeroes: Heroes = heroesStorage.getHeroes() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.dota2LikedHeroesTableView.reloadData()
            }
        }
    }
    
    private let dota2LikedHeroesTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(Dota2HeroTableViewCell.self, forCellReuseIdentifier: Dota2HeroTableViewCell.identifier)
        return tableView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBarWithLogo()
        view.backgroundColor = .systemBackground
        view.addSubview(dota2LikedHeroesTableView)
        
        dota2LikedHeroesTableView.delegate = self
        dota2LikedHeroesTableView.dataSource = self
    }
    
    
    init(heroesStorage: TemporaryStorageForHeroes, imageFetcher: ImageFetcher) {
        self.heroesStorage = heroesStorage
        self.imageFetcher = imageFetcher
        super.init(nibName: nil, bundle: nil)
        
        heroesStorage.likedHeroesDidChangeHandler = { [weak self] in
            self?.likedHeroes = heroesStorage.getHeroes()
           
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
           super.viewDidLayoutSubviews()
           dota2LikedHeroesTableView.frame = view.frame
       }

}


extension LikedHeroesViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likedHeroes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Dota2HeroTableViewCell.identifier, for: indexPath) as? Dota2HeroTableViewCell else { return UITableViewCell() }
        let model = likedHeroes[indexPath.row]
        
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
        return 150
    }
}
