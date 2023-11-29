//
//  MainTabBarViewController.swift
//  Dota2Hero
//
//  Created by Саша Восколович on 01.11.2023.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
    
    // MARK: - Properties
    
    private let fetcher: FetcherService
    private let heroesManager: DataManager
    private let factory: Factory
    
    
    
    // MARK: - Initialization
    
    init(heroesManager: DataManager, fetcher: FetcherService, factory: Factory) {
        self.heroesManager = heroesManager
        self.fetcher = fetcher
        self.factory = factory
        super.init(nibName: nil, bundle: nil)
        setTabBar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: - Helper Methods
    
    private func setTabBar() {
        
        let vc1 = UINavigationController(
            rootViewController: HomeViewController(heroesManager: heroesManager, fetcher: fetcher))
        
        let vc2 = UINavigationController(
            rootViewController: LikedHeroesViewController(heroesManager: heroesManager, fetcher: fetcher, factory: factory))
        
        vc1.tabBarItem = createTabBarItem(
            imageName: "house", selectedImageName: "house.fill")
        
        vc2.tabBarItem = createTabBarItem(
            imageName: "hand.thumbsup", selectedImageName: "hand.thumbsup.fill")
        
        
        setViewControllers([vc1, vc2], animated: true)
    }
    
    
    // MARK: - Helper Methods
    
    private func createTabBarItem(imageName: String, selectedImageName: String) -> UITabBarItem {
        let tabBarItem = UITabBarItem()
        tabBarItem.image = UIImage(systemName: imageName)
        tabBarItem.selectedImage =  UIImage(systemName: selectedImageName)
        return tabBarItem
    }
}

