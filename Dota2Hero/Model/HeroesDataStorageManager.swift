//
//  HeroesDataStorageManager.swift
//  Dota2Hero
//
//  Created by Саша Восколович on 06.11.2023.
//

import Foundation



protocol HeroInteractionHandler {
    func completeHero(withID id: Int)
    func getAmountOfAll() -> Int
    func getInAll(by index: IndexPath) -> Dota2HeroModel 
    func getInAll(by id: Int) -> Dota2HeroModel 
    func getAmountOfLiked() -> Int
    func getInLiked(by indexPath: IndexPath) -> Dota2HeroModel
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
    
    func getInAll(by id: Int) -> Dota2HeroModel {
        provider.getHero(by: id)
    }
    
    func getInAll(by indexPath: IndexPath) -> Dota2HeroModel {
        return provider.getHero(by: indexPath)
    }
    
    func getAmountOfAll() -> Int {
        return provider.allHeroes.count
    }
    
    func getAmountOfLiked() -> Int {
        return provider.likedHeroes.count
    }
    
    func getInLiked(by indexPath: IndexPath) -> Dota2HeroModel {
        return provider.getLiked(by: indexPath)
    }
    
}



