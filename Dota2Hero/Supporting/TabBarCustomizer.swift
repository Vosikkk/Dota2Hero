//
//  TabBarCustomizer.swift
//  Dota2Hero
//
//  Created by Саша Восколович on 12.12.2023.
//

import UIKit

class TabBarCustomizer {
    
    static func customizeTabBar() {
        UITabBar.appearance().tintColor = .yellow
        UITabBar.appearance().backgroundColor = .darkGray
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
}
