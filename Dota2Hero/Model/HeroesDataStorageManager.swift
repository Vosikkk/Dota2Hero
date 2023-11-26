//
//  TemporaryStorageForHeroes.swift
//  Dota2Hero
//
//  Created by Саша Восколович on 06.11.2023.
//

import Foundation


extension Notification.Name {
    static let changeLikeDislike = Notification.Name("changedLiked")
}

protocol HeroesProvider {
      var allHeroes: Heroes { get set }
      var likedHeroes: Heroes { get set }
      func getHero(by ID: Int) -> Dota2HeroModel
      func add(heroes: Heroes)
      func getHero(by indexPath: IndexPath) -> Dota2HeroModel
      func getLiked(by indexPath: IndexPath) -> Dota2HeroModel
}

protocol HeroesUpdater {
    func update(_ hero: Dota2HeroModel)
    
}

protocol LikedHeroesUpdater {
    func updateInLiked(_ hero: Dota2HeroModel)
}

protocol NotificationsSender {
    func postNotification(for name: Notification.Name)
}

protocol HeroInteractionHandler {
    func completeHero(withID id: Int)
    func getAmountOfAll() -> Int
    func get(by index: IndexPath) -> Dota2HeroModel 
    func get(by id: Int) -> Dota2HeroModel 
    func getAmountOfLiked() -> Int
    func getOnlyLiked(by indexPath: IndexPath) -> Dota2HeroModel
}


class NotificationManager: NotificationsSender {
    func postNotification(for name: Notification.Name) {
        NotificationCenter.default.post(
            name: name,
            object: nil
        )
    }
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

class HeroesDataStorageManager: HeroInteractionHandler {
    
    private let notification: NotificationsSender
    private let updater: HeroesUpdater & LikedHeroesUpdater
    private let provider: HeroesProvider
    
    
    init(updater: HeroesUpdater & LikedHeroesUpdater, provider: HeroesProvider, notification: NotificationsSender) {
        self.updater = updater
        self.provider = provider
        self.notification = notification
    }
    
    func completeHero(withID id: Int) {
        var hero = provider.getHero(by: id)
        hero.isLiked.toggle()
        updater.update(hero)
        updater.updateInLiked(hero)
        notification.postNotification(for: .changeLikeDislike)
    }
    
    func add(_ heroes: Heroes) {
        provider.add(heroes: heroes)
    }
    
    func get(by id: Int) -> Dota2HeroModel {
        provider.getHero(by: id)
    }
    
    func get(by indexPath: IndexPath) -> Dota2HeroModel {
        return provider.getHero(by: indexPath)
    }
    
    func getAmountOfAll() -> Int {
        return provider.allHeroes.count
    }
    
    func getAmountOfLiked() -> Int {
        return provider.likedHeroes.count
    }
    
    func getOnlyLiked(by indexPath: IndexPath) -> Dota2HeroModel {
        return provider.getLiked(by: indexPath)
    }
    
}



final class HeroProviderManager: HeroesProvider {
    
    
    // MARK: - Properties
    
    var likedHeroes: Heroes = []
    
    var allHeroes: Heroes = []

    
    // MARK: - Public Methods
    
    // Retrieve hero by ID
    func getHero(by ID: Int) -> Dota2HeroModel {
        let index = allHeroes.indexOfHero(withID: ID)
        return allHeroes[index]
    }
    
    func getHero(by index: IndexPath) -> Dota2HeroModel {
        return allHeroes[index.row]
    }

    func getLiked(by index: IndexPath) -> Dota2HeroModel {
        return likedHeroes[index.row]
    }
    
    // Add all heroes to the allHeroes array
    func add(heroes: Heroes) {
        allHeroes = heroes
    }
}


