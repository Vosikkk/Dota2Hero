//
//  TemporaryStorageForHeroes.swift
//  Dota2Hero
//
//  Created by Саша Восколович on 06.11.2023.
//

import Foundation


final class TemporaryStorageForHeroes {
    
    private(set) var likedHeroes: Heroes = [] {
        didSet {
            likedHeroesDidChangeHandler?()
        }
    }
    
    private(set) var allHeroes: Heroes = []
       
    
    var likedHeroesDidChangeHandler: (() -> Void)?
    var allHeroesChangedHandler: ((Dota2HeroModel) -> Void)?
    
    
    func addAllHeroes(heroes: Heroes) {
        allHeroes = heroes
    }
    
    func resetLikedState(for heroID: Int) {
        if let index = allHeroes.firstIndex(where: { $0.heroID == heroID }) {
            allHeroes[index].isLiked = false
            allHeroesChangedHandler?(allHeroes[index])
        }
    }
    
    func addLiked(hero: Dota2HeroModel) {
        likedHeroes.append(hero)
    }
    
    func removeLikedHero(by ID: Int) {
        likedHeroes.removeAll { $0.heroID == ID }
    }
    
    func getAllHeroes() -> Heroes {
        return allHeroes
    }
    
    func getLikedHeroes() -> Heroes {
        return likedHeroes
    }
}
