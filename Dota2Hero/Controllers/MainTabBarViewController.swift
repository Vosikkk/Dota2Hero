//
//  MainTabBarViewController.swift
//  Dota2Hero
//
//  Created by Саша Восколович on 01.11.2023.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
    private let dota2API: APIManager
    private let imageFetcher: ImageFetcherService
    private let heroesManager: HeroInteractionHandler
    private let factory: Factory
    
    init(dota2API: APIManager, imageFetcher: ImageFetcherService, heroesManager: HeroInteractionHandler, factory: Factory) {
        self.dota2API = dota2API
        self.imageFetcher = imageFetcher
        self.heroesManager = heroesManager
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
            rootViewController: HomeViewController(dota2API: dota2API, imageFetcher: imageFetcher, heroesManager: heroesManager))
        
        let vc2 = UINavigationController(
            rootViewController: LikedHeroesViewController(heroesManager: heroesManager, imageFetcher: imageFetcher, factory: factory))
        
        vc1.tabBarItem = createTabBarItem(
            imageName: "house", selectedImageName: "house.fill")
        
        vc2.tabBarItem = createTabBarItem(
            imageName: "hand.thumbsup", selectedImageName: "hand.thumbsup.fill")
        
        
        setViewControllers([vc1, vc2], animated: true)
    }
    
    
    private func createTabBarItem(imageName: String, selectedImageName: String) -> UITabBarItem {
        let tabBarItem = UITabBarItem()
        tabBarItem.image = UIImage(systemName: imageName)
        tabBarItem.selectedImage =  UIImage(systemName: selectedImageName)
        return tabBarItem
    }
}

