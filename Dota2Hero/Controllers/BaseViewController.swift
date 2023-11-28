//
//  BaseViewController.swift
//  Dota2Hero
//
//  Created by Саша Восколович on 08.11.2023.
//

import UIKit

class BaseViewController: UIViewController, NavigationBarDota2Logo {
    
    
    // MARK: - Properties
    
    typealias DataSource = UITableViewDiffableDataSource<Section, Dota2HeroModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Dota2HeroModel>
    
    var screenSize: CGFloat? {
        return UIScreen.current?.bounds.height
    }
    
    var updaterHandler: ((Snapshot) -> Void)?
    
    
    enum Section {
        case main
    }
    
    var heroesManager: DataManager
    var fetcher: FetcherService
    
    let heroesTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(Dota2HeroTableViewCell.self, forCellReuseIdentifier: Dota2HeroTableViewCell.identifier)
        return tableView
    }()
    
    
    // MARK: - Inirialization
    
    init(heroesManager: DataManager, fetcher: FetcherService) {
        self.fetcher = fetcher
        self.heroesManager = heroesManager
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
    
    
    func loadImage(for hero: Dota2HeroModel, into cell: Dota2HeroTableViewCell, array: Heroes) {
        Task {
            do {
                let image = try await fetcher.getImage(by: APIEndpoint.image(hero.img))
                cell.configure(model: hero, with: image)
                updateSnapshot(reloadOf: array)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func updateSnapshot(reloadOf array: Heroes) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(array)
        updaterHandler?(snapshot)
    }
}








