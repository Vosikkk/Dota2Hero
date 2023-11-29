//
//  HeroesDataStorageManager.swift
//  Dota2Hero
//
//  Created by Саша Восколович on 06.11.2023.
//

import Foundation

// Protocol defining the contract for a data manager

protocol DataManager {
    var likedHeroes: Heroes { get set }
    var allHeroes: Heroes { get set }
    func completeHero(withID id: Int)
    func getHero(by ID: Int) -> Dota2HeroModel
}

// Class implementing the DataManager protocol

class HeroesDataManager: DataManager {
    
    // An object responsible for updating hero data
   
    private let updater: HeroesUpdater & LikedHeroesUpdater
    
    var likedHeroes: Heroes = []

    var allHeroes: Heroes = []

    // Initializer
    
    init(updater: HeroesUpdater & LikedHeroesUpdater) {
        self.updater = updater
    }
    
    // Method to mark a hero as complete (liked/disliked)
    
    func completeHero(withID id: Int) {
        var hero = getHero(by: id)
        hero.isLiked.toggle()
        updater.update(hero, in: &allHeroes)
        updater.updateInLiked(hero, in: &likedHeroes)
    }
    
    // Method to get a hero by its ID
    
    func getHero(by ID: Int) -> Dota2HeroModel {
        let index = allHeroes.indexOfHero(withID: ID)
        return allHeroes[index]
    }
    
    // Method to add a collection of heroes to the data manager
    
    func add(_ heroes: Heroes) {
         allHeroes = heroes
    }
}




