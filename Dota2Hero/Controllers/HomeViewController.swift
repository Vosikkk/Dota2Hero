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
   
    private let dota2HeroesTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(Dota2HeroTableViewCell.self, forCellReuseIdentifier: Dota2HeroTableViewCell.identifier)
        return tableView
    }()
    
    private var screenSize: CGFloat {
        if let size = UIScreen.current?.bounds.height {
            return size
        }
        return 1000
    }
    
    private var heroes: Heroes = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.dota2HeroesTableView.reloadData()
            }
        }
    }
    
    
    init(dota2API: Dota2HeroFetcher, imageFetcher: ImageFetcher) {
        self.dota2API = dota2API
        self.imageFetcher = imageFetcher
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
        
        dota2HeroesTableView.delegate = self
        dota2HeroesTableView.dataSource = self
    }
    
    
    private func fetch() {
        dota2API.fetch(page: 1, pageSize: 10) { [weak self] result in
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
    
    
    func configureRolesLabel(with attackType: String, and roles: [String]) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString()
        let attackTypeString = NSMutableAttributedString(string: "\(attackType.uppercased()) - ", attributes: [
            .font: UIFont.systemFont(ofSize: 12, weight: .bold),
            .foregroundColor: UIColor.black
        ])
        attributedString.append(attackTypeString)
        if !roles.isEmpty {
            let rolesString = roles.map { $0.uppercased() }.joined(separator: ", ")
            let rolesAttributedString = NSAttributedString(string: rolesString, attributes: [
                .font: UIFont.systemFont(ofSize: 12),
                .foregroundColor: UIColor.lightGray
            ])
            attributedString.append(rolesAttributedString)
        }
        
        return attributedString
    }
}



extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heroes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Dota2HeroTableViewCell.identifier, for: indexPath) as? Dota2HeroTableViewCell else { return UITableViewCell() }
        let model = heroes[indexPath.row]
        let atrributedText = configureRolesLabel(with: model.attackType, and: model.roles)
        imageFetcher.fetchImage(from: model.imageURL ) { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    cell.configure(model: model, with: image, textForRoles: atrributedText)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.orientation.isPortrait {
            return screenSize / 5
        }
        return 150
    }
}

