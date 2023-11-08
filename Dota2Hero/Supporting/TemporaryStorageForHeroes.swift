//
//  TemporaryStorageForHeroes.swift
//  Dota2Hero
//
//  Created by Саша Восколович on 06.11.2023.
//

import Foundation


final class TemporaryStorageForHeroes {
    
    private var likedDota2Hero: Heroes = [] {
        didSet {
            likedHeroesDidChangeHandler?()
        }
    }
    
    private var allDota2Hero: Heroes = [] 
       
    
    var likedHeroesDidChangeHandler: (() -> Void)?
    var allHeroesDidChangeHandler: ((Dota2HeroModel) -> Void)?
    
    
    func addAllHero(heroes: Heroes) {
        allDota2Hero = heroes
    }
    
    func changeSimpleModels(by ID: Int) {
        if let index = allDota2Hero.firstIndex(where: { $0.heroID == ID }) {
            allDota2Hero[index].isLiked = false
            allHeroesDidChangeHandler?(allDota2Hero[index])
        }
    }
    
    func addLiked(hero: Dota2HeroModel) {
        likedDota2Hero.append(hero)
    }
    
    func removeLikedHero(by ID: Int) {
        if let index = likedDota2Hero.firstIndex(where: { $0.heroID == ID }) {
            likedDota2Hero[index].isLiked = false
            likedDota2Hero = likedDota2Hero.filter { $0.isLiked }
        }
    }
    
    func getAllHeroes() -> Heroes {
        return allDota2Hero
    }
    
    func getLikedHeroes() -> Heroes {
        return likedDota2Hero
    }
}
