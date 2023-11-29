//
//  HeroesUdapter.swift
//  Dota2Hero
//
//  Created by Саша Восколович on 26.11.2023.
//

import Foundation

// Protocol defining the contract for updating a collection of heroes
    
protocol HeroesUpdater {
    func update(_ hero: Dota2HeroModel, in storage: inout Heroes)
}

// Protocol defining the contract for updating a collection of liked heroes

protocol LikedHeroesUpdater {
    func updateInLiked(_ hero: Dota2HeroModel, in storage: inout Heroes)
}


class AllHeroesUpdater: HeroesUpdater, LikedHeroesUpdater {
    
    // Method to update a hero in a collection of heroes
    
    func update(_ hero: Dota2HeroModel, in storage: inout Heroes) {
        let index = storage.indexOfHero(withID: hero.heroID)
        storage[index].isLiked = hero.isLiked
    }
    
    // Method to update a hero in a collection of liked heroes
    
    func updateInLiked(_ hero: Dota2HeroModel, in storage: inout Heroes) {
        if !hero.isLiked {
            storage.removeAll { $0.heroID == hero.heroID }
        } else {
            storage.append(hero)
        }
    }
}
