//
//  MainTabBarViewController.swift
//  Dota2Hero
//
//  Created by Саша Восколович on 01.11.2023.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTabBar()

        
    }
    
    private func setTabBar() {
        let vc1 = UINavigationController(rootViewController: HomeViewController()) 
        let vc2 = UINavigationController(rootViewController: LikedHeroesViewController()) 
        
        vc1.tabBarItem = createTabBarItem(imageName: "house", selectedImageName: "house.fill")
        vc2.tabBarItem = createTabBarItem(imageName: "hand.thumbsup", selectedImageName: "hand.thumbsup.fill")
        
        
        setViewControllers([vc1, vc2], animated: true)
    }
    
    
    
    private func createTabBarItem(imageName: String, selectedImageName: String) -> UITabBarItem {
        let tabBarItem = UITabBarItem()
        tabBarItem.image = UIImage(systemName: imageName)
        tabBarItem.selectedImage =  UIImage(systemName: selectedImageName)
        return tabBarItem
    }
}

protocol NavigationBarDota2Logo {
    func configureNavigationBarWithLogo()
}

extension UIViewController: NavigationBarDota2Logo {
    func configureNavigationBarWithLogo() {
        let logoImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 36))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.image = UIImage(named: "dota2_logo")
        
        let middleView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 36))
        middleView.addSubview(logoImageView)
        navigationItem.titleView = middleView
    }
}
