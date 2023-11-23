//
//  MainTabBarViewController.swift
//  Dota2Hero
//
//  Created by Саша Восколович on 01.11.2023.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBar()
    }
    
    
    // MARK: - Helper Methods
    
    private func setTabBar() {
        
        let dota2API: APIManager = Dota2HeroFetcher()
        let imageFetcher: ImageFetcherService = ImageFetcher()
        let heroesStorage: HeroDataManager = HeroDataManager()
        let factory: Factory = LabelFactory()
        
        let vc1 = UINavigationController(
            rootViewController: HomeViewController(dota2API: dota2API, imageFetcher: imageFetcher, heroesStorage: heroesStorage))
        
        let vc2 = UINavigationController(
            rootViewController: LikedHeroesViewController(heroesStorage: heroesStorage, imageFetcher: imageFetcher, factory: factory))
        
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

