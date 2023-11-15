//
//  LikedHeroesViewController.swift
//  Dota2Hero
//
//  Created by Саша Восколович on 01.11.2023.
//

import UIKit


class LikedHeroesViewController: BaseViewController, Dota2HeroTableViewCellDelegate {
    
    private var likedObserver: NSObjectProtocol?
   
    private let factory: LabelFactory
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    init(heroesStorage: HeroDataManager, imageFetcher: ImageFetcher, factory: LabelFactory) {
        self.factory = factory
        super.init(heroesStorage: heroesStorage, imageFetcher: imageFetcher)
        
        likedObserver = NotificationCenter.default.addObserver(
            forName: .changeInLiked,
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
    
    override func setupUI() {
        super.setupUI()
        heroesTableView.delegate = self
        heroesTableView.dataSource = self
    }
    
    
    func didTapOnImageHeroView(heroID: Int, image: UIImage) {
        let model = heroesStorage.likedHeroes.filter { $0.heroID == heroID }
        if let hero = model.first {
            let vc = HeroDetailsViewController(factory: factory, heroesStorage: heroesStorage)
            vc.configureUI(with: hero, and: image)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}


extension LikedHeroesViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heroesStorage.likedHeroes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Dota2HeroTableViewCell.identifier, for: indexPath) as? Dota2HeroTableViewCell else { return UITableViewCell() }
    
        cell.delegate = self
        let hero = heroesStorage.likedHeroes[indexPath.row]
        
        cell.likeButton.setSelected(selected: hero.isLiked, animated: false)
        
        cell.registrationHandler = { [weak self] in
            guard let self = self else { return }
            tableView.performBatchUpdates {
                self.heroesStorage.completeHero(withID: hero.heroID)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } completion: { finished in
               
            }
        }
        
        imageFetcher.fetchImage(from: heroesStorage.likedHeroes[indexPath.row].imageURL) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    cell.configure(model: self.heroesStorage.likedHeroes[indexPath.row], with: image)
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
