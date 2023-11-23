//
//  TemporaryStorageForHeroes.swift
//  Dota2Hero
//
//  Created by Саша Восколович on 06.11.2023.
//

import Foundation


extension Notification.Name {
    static let changeInLiked = Notification.Name("changedInLikedStorage")
    static let changeInAllHeroes = Notification.Name("changedInGeneralStorage")
}

protocol HeroesProvider {
    var allHeroes: Heroes { get }
    var likedHeroes: Heroes { get }
    func getHero(by ID: Int) -> Dota2HeroModel
}

protocol HeroesUpdater {
    func updateInAll(_ hero: Dota2HeroModel)
}

protocol LikedHeroesUpdater {
    func updateInLiked(_ hero: Dota2HeroModel)
}

protocol NotificationsSender {
    func postNotification(for name: Notification.Name)
}

protocol HeroInteractionHandler: HeroesUpdater, LikedHeroesUpdater {
    func completeHero(withID id: Int)
}



final class HeroDataManager: HeroesProvider, NotificationsSender,  HeroInteractionHandler {
    
    
    // MARK: - Properties
    
   private(set) var likedHeroes: Heroes = [] {
        didSet {
            postNotification(for: .changeInLiked)
        }
    }
    
   private(set) var allHeroes: Heroes = [] {
        didSet {
            postNotification(for: .changeInAllHeroes)
        }
    }
    
    // MARK: - Public Methods
    
    // Retrieve hero by ID
    func getHero(by ID: Int) -> Dota2HeroModel {
        let index = allHeroes.indexOfHero(withID: ID)
        return allHeroes[index]
    }
    
    
    // Update hero in the allHeroes array
    func updateInAll(_ hero: Dota2HeroModel) {
        let index = allHeroes.indexOfHero(withID: hero.heroID)
        allHeroes[index].isLiked = hero.isLiked
    }
    
    
    // Toggle like status of a hero and update both allHeroes and likedHeroes arrays
    func completeHero(withID id: Int) {
        var hero = getHero(by: id)
        hero.isLiked.toggle()
        updateInAll(hero)
        updateInLiked(hero)
    }
    
    
    // Update likedHeroes array based on a hero's like status
    func updateInLiked(_ hero: Dota2HeroModel) {
        if !hero.isLiked {
            likedHeroes.removeAll { $0.heroID == hero.heroID }
        } else {
            likedHeroes.append(hero)
        }
    }
    
    // Add all heroes to the allHeroes array
    func addAllHeroes(heroes: Heroes) {
        allHeroes = heroes
    }
    
    
    // MARK: - Private Methods
        
    // Post a notification for a given name
    func postNotification(for name: Notification.Name) {
           NotificationCenter.default.post(
               name: name,
               object: nil
           )
       }
}


