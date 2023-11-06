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
    
    var likedHeroesDidChangeHandler: (() -> Void)?
    
    func addLiked(hero: Dota2HeroModel) {
        likedDota2Hero.append(hero)
    }
    
    func changeModel(by ID: Int) {
        if let index = likedDota2Hero.firstIndex(where: { $0.heroID == ID }) {
            likedDota2Hero[index].isLiked = false
        }
    }
    
    func removeLikedHero() {
        likedDota2Hero = likedDota2Hero.filter { $0.isLiked }
    }
    
    func getHeroes() -> Heroes {
        return likedDota2Hero
    }
}
