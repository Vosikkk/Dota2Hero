//
//  HeroesUdapter.swift
//  Dota2Hero
//
//  Created by Саша Восколович on 26.11.2023.
//

import Foundation


protocol HeroesUpdater {
    func update(_ hero: Dota2HeroModel, in storage: inout Heroes)
}

protocol LikedHeroesUpdater {
    func updateInLiked(_ hero: Dota2HeroModel, in storage: inout Heroes)
}


class AllHeroesUpdater: HeroesUpdater, LikedHeroesUpdater {
    
    func update(_ hero: Dota2HeroModel, in storage: inout Heroes) {
        let index = storage.indexOfHero(withID: hero.heroID)
        storage[index].isLiked = hero.isLiked
    }
    
    func updateInLiked(_ hero: Dota2HeroModel, in storage: inout Heroes) {
        if !hero.isLiked {
            storage.removeAll { $0.heroID == hero.heroID }
        } else {
            storage.append(hero)
        }
    }
}
