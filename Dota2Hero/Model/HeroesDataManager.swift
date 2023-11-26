//
//  HeroesDataStorageManager.swift
//  Dota2Hero
//
//  Created by Саша Восколович on 06.11.2023.
//

import Foundation


protocol DataManager {
    var likedHeroes: Heroes { get set }
    var allHeroes: Heroes { get set }
    func completeHero(withID id: Int)
    func getHero(by ID: Int) -> Dota2HeroModel
}


class HeroesDataManager: DataManager {
    
    private let notification: NotificationsSender
    private let updater: HeroesUpdater & LikedHeroesUpdater
    
    var likedHeroes: Heroes = []

    var allHeroes: Heroes = []

    
    init(updater: HeroesUpdater & LikedHeroesUpdater, notification: NotificationsSender) {
        self.updater = updater
        self.notification = notification
    }
    
    func completeHero(withID id: Int) {
        var hero = getHero(by: id)
        hero.isLiked.toggle()
        updater.update(hero, in: &allHeroes)
        updater.updateInLiked(hero, in: &likedHeroes)
        notification.postNotification(for: .changeLikeDislike)
    }
    
    func getHero(by ID: Int) -> Dota2HeroModel {
        let index = allHeroes.indexOfHero(withID: ID)
        return allHeroes[index]
    }
    
    func add(_ heroes: Heroes) {
         allHeroes = heroes
    }
}




