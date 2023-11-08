//
//  BaseViewController.swift
//  Dota2Hero
//
//  Created by Саша Восколович on 08.11.2023.
//

import UIKit

class BaseViewController: UIViewController {
    
    var heroes: Heroes = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.heroesTableView.reloadData()
            }
        }
    }
    
    var screenSize: CGFloat? {
        return UIScreen.current?.bounds.height
    }
    
    var heroesStorage: TemporaryStorageForHeroes
    var imageFetcher: ImageFetcher
    
    let heroesTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(Dota2HeroTableViewCell.self, forCellReuseIdentifier: Dota2HeroTableViewCell.identifier)
        return tableView
    }()
    
    init(heroesStorage: TemporaryStorageForHeroes, imageFetcher: ImageFetcher) {
        self.heroesStorage = heroesStorage
        self.imageFetcher = imageFetcher
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(heroesTableView)
        
        configureNavigationBarWithLogo()
        
        heroesTableView.allowsSelection = false
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        heroesTableView.frame = view.frame
    }
}








