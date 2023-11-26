//
//  HeroesUdapter.swift
//  Dota2Hero
//
//  Created by Саша Восколович on 26.11.2023.
//

import Foundation


protocol HeroesUpdater {
    func update(_ hero: Dota2HeroModel)
}

protocol LikedHeroesUpdater {
    func updateInLiked(_ hero: Dota2HeroModel)
}



class AllHeroesUpdater: HeroesUpdater, LikedHeroesUpdater {
    
    private var heroesProvider: HeroesProvider
    
    init(heroesProvider: HeroesProvider) {
        self.heroesProvider = heroesProvider
    }
    
    func update(_ hero: Dota2HeroModel) {
        let index = heroesProvider.allHeroes.indexOfHero(withID: hero.heroID)
        heroesProvider.allHeroes[index].isLiked = hero.isLiked
    }
    
    func updateInLiked(_ hero: Dota2HeroModel) {
        if !hero.isLiked {
            heroesProvider.likedHeroes.removeAll { $0.heroID == hero.heroID }
        } else {
            heroesProvider.likedHeroes.append(hero)
        }
    }
}
