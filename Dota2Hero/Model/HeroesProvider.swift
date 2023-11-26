//
//  HeroesProvider.swift
//  Dota2Hero
//
//  Created by Саша Восколович on 26.11.2023.
//

import Foundation


protocol HeroesProvider {
      var allHeroes: Heroes { get set }
      var likedHeroes: Heroes { get set }
      func getHero(by ID: Int) -> Dota2HeroModel
      func add(heroes: Heroes)
      func getHero(by indexPath: IndexPath) -> Dota2HeroModel
      func getLiked(by indexPath: IndexPath) -> Dota2HeroModel
}


final class HeroesProviderManager: HeroesProvider {
    
    
    // MARK: - Properties
    
    var likedHeroes: Heroes = []
    
    var allHeroes: Heroes = []

    
    // MARK: - Public Methods
    
    // Retrieve hero by ID
    func getHero(by ID: Int) -> Dota2HeroModel {
        let index = allHeroes.indexOfHero(withID: ID)
        return allHeroes[index]
    }
    
    func getHero(by index: IndexPath) -> Dota2HeroModel {
        return allHeroes[index.row]
    }

    func getLiked(by index: IndexPath) -> Dota2HeroModel {
        return likedHeroes[index.row]
    }
    
    // Add all heroes to the allHeroes array
    func add(heroes: Heroes) {
        allHeroes = heroes
    }
}
