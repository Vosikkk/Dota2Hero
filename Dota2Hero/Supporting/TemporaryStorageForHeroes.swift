//
//  TemporaryStorageForHeroes.swift
//  Dota2Hero
//
//  Created by Саша Восколович on 06.11.2023.
//

import Foundation


extension Notification.Name {
    static let changeInLiked = Notification.Name("like")
    static let changeLikeOnAllHeroes = Notification.Name("allHeroesChanged")
}


final class TemporaryStorageForHeroes {
    
    private(set) var likedHeroes: Heroes = [] {
        didSet {
            postNotification(for: .changeInLiked, with: "hero", data: likedHeroes)
        }
    }
    
    private(set) var allHeroes: Heroes = []
       

    func addAllHeroes(heroes: Heroes) {
        allHeroes = heroes
    }
    
    func addLiked(hero: Dota2HeroModel) {
        updateHeroLikedStatus(hero)
        likedHeroes.append(hero)
    }
    
    func removeLiked(hero: Dota2HeroModel) {
        updateHeroLikedStatus(hero)
        likedHeroes.removeAll { $0.heroID == hero.heroID }
    }
    
    func getAllHeroes() -> Heroes {
        return allHeroes
    }
    
    func getLikedHeroes() -> Heroes {
        return likedHeroes
    }
    
    private func updateHeroLikedStatus(_ hero: Dota2HeroModel) {
        guard let index = allHeroes.firstIndex(where: { $0.heroID == hero.heroID }) else { return }
        allHeroes[index].isLiked = hero.isLiked
        postNotification(for: .changeLikeOnAllHeroes, with: "hero", data: allHeroes[index])
    }
    
    private func postNotification(for name: Notification.Name, with key: String, data: Any) {
           NotificationCenter.default.post(
               name: name,
               object: nil,
               userInfo: [key: data]
           )
       }
}


