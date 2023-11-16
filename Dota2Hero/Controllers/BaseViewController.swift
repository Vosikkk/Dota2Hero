//
//  BaseViewController.swift
//  Dota2Hero
//
//  Created by Саша Восколович on 08.11.2023.
//

import UIKit

class BaseViewController: UIViewController, NavigationBarDota2Logo {
    
    
    // MARK: - Properties
    
    var screenSize: CGFloat? {
        return UIScreen.current?.bounds.height
    }
    
    var heroesStorage: HeroDataManager
    var imageFetcher: ImageFetcher
    
    
    
    let heroesTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(Dota2HeroTableViewCell.self, forCellReuseIdentifier: Dota2HeroTableViewCell.identifier)
        return tableView
    }()
    
    
    // MARK: - Inirialization
    
    init(heroesStorage: HeroDataManager, imageFetcher: ImageFetcher) {
        self.heroesStorage = heroesStorage
        self.imageFetcher = imageFetcher
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure View
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        heroesTableView.frame = view.frame
    }
    
    
    func setupUI() {
        
        view.backgroundColor = .systemBackground
        view.addSubview(heroesTableView)
        
        configureNavigationBarWithLogo()
        
        heroesTableView.allowsSelection = false
    }
    
    func updateTable() {
         DispatchQueue.main.async { [weak self] in
             self?.heroesTableView.reloadData()
         }
     }
}








