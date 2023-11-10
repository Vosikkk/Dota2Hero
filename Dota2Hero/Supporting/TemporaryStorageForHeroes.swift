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
    
    func addLiked(hero: Dota2HeroModel) {
        updateHeroLikedStatus(hero)
        likedHeroes.append(hero)
    }
    
    func removeLiked(hero: Dota2HeroModel) {
        updateHeroLikedStatus(hero)
        likedHeroes.removeAll { $0.heroID == hero.heroID }
    }
    
    func getAllHeroes() -> Heroes {
        return allHeroes
    }
    
    func getLikedHeroes() -> Heroes {
        return likedHeroes
    }
    
    private func updateHeroLikedStatus(_ hero: Dota2HeroModel) {
        guard let index = allHeroes.firstIndex(where: { $0.heroID == hero.heroID }) else { return }
        allHeroes[index].isLiked = hero.isLiked
        allHeroesChangedHandler?(allHeroes[index])
    }
}
