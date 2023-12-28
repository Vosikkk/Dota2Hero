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
   
    private let updaterInAll: HeroesUpdater
    private let updaterInLiked: HeroesUpdater
    
    var likedHeroes: Heroes = []

    var allHeroes: Heroes = []

    // Initializer
    
    init(updaterInAll: HeroesUpdater, updaterInLiked: HeroesUpdater) {
        self.updaterInAll = updaterInAll
        self.updaterInLiked = updaterInLiked
    }
    
    // Method to mark a hero as complete (liked/disliked)
    
    func completeHero(withID id: Int) {
        var hero = getHero(by: id)
        hero.isLiked.toggle()
        updaterInAll.update(hero, in: &allHeroes)
        updaterInLiked.update(hero, in: &likedHeroes)
    }
    
    // Method to get a he ro by its ID
    
    func getHero(by ID: Int) -> Dota2HeroModel {
        let index = allHeroes.indexOfHero(withID: ID)
        return allHeroes[index]
    }
    
    // Method to add a collection of heroes to the data manager
    
    func add(_ heroes: Heroes) {
         allHeroes = heroes
    }
}




