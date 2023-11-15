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


final class HeroDataManager {
    
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
    
    func getHero(by ID: Int) -> Dota2HeroModel {
        let index = allHeroes.indexOfHero(withID: ID)
        return allHeroes[index]
    }
    
    func updateInAll(_ hero: Dota2HeroModel) {
        let index = allHeroes.indexOfHero(withID: hero.heroID)
        allHeroes[index].isLiked = hero.isLiked
    }
    
    func completeHero(withID id: Int) {
        var hero = getHero(by: id)
        hero.isLiked.toggle()
        updateInAll(hero)
        updateInLiked(hero)
    }
    
    func updateInLiked(_ hero: Dota2HeroModel) {
        if !hero.isLiked {
            likedHeroes.removeAll { $0.heroID == hero.heroID }
        } else {
            likedHeroes.append(hero)
        }
    }
    
    
    func addAllHeroes(heroes: Heroes) {
        allHeroes = heroes
    }
    
    private func postNotification(for name: Notification.Name) {
           NotificationCenter.default.post(
               name: name,
               object: nil
           )
       }
}


