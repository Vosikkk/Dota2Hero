//
//  Dota2HeroTests.swift
//  Dota2HeroTests
//
//  Created by Саша Восколович on 02.12.2023.
//
@testable import Dota2Hero
import XCTest

final class Dota2HeroTests: XCTestCase {
    
    var sut: HeroesUpdater!
   
    var heroesAll: Heroes = [Dota2HeroModel(name: "", localizedName: "", primaryAttr: "", attackType: "", roles: [], img: "", baseMana: 0.0, baseHealth: 0.0, baseManaRegen: 0.0, baseHealthRegen: 0.0, baseAttackMin: 0.0, baseAttackMax: 0.0, attackRange: 0.0, attackSpeed: 0.0, moveSpeed: 0.0, baseStr: 0.0, baseAgi: 0.0, baseInt: 0.0, agiGain: 0.0, intGain: 0.0, strGain: 0.0, heroID: 0)]
    
    var model: Dota2HeroModel = Dota2HeroModel(name: "", localizedName: "", primaryAttr: "", attackType: "", roles: [], img: "", baseMana: 0.0, baseHealth: 0.0, baseManaRegen: 0.0, baseHealthRegen: 0.0, baseAttackMin: 0.0, baseAttackMax: 0.0, attackRange: 0.0, attackSpeed: 0.0, moveSpeed: 0.0, baseStr: 0.0, baseAgi: 0.0, baseInt: 0.0, agiGain: 0.0, intGain: 0.0, strGain: 0.0, heroID: 0)
    
    var likedHeroes: Heroes = []
    
    
    func test_changesLikeState_inAllHeroesStorage() {
        sut = UpdaterInAll()
        
        model.isLiked = true
        
        XCTAssertFalse(heroesAll[0].isLiked)
        
        sut.update(model, in: &heroesAll)
        
        XCTAssertTrue(heroesAll[0].isLiked)
    }
    
    func test_addOrDeleteHeroInLiked_whenItWasDislikedLiked() {
        
        sut = UpdaterInLiked()
        
        model.isLiked = true
        
        XCTAssertTrue(likedHeroes.isEmpty, "We have empty mock array so we can test")
        
        sut.update(model, in: &likedHeroes)
        
        XCTAssertTrue(!likedHeroes.isEmpty, "Array must have one element \(likedHeroes.count)")
        
        model.isLiked = false
        
        sut.update(model, in: &likedHeroes)
        
        XCTAssertTrue(likedHeroes.isEmpty, "We've changed on dislike, array must be empty \(likedHeroes.count)")
        
    }

}





class UpdaterInAll: HeroesUpdater {
    
    func update(_ hero: Dota2HeroModel, in storage: inout Heroes) {
        let index = storage.indexOfHero(withID: hero.heroID)
        storage[index].isLiked = hero.isLiked
    }
    
}

class UpdaterInLiked: HeroesUpdater {
    
    func update(_ hero: Dota2HeroModel, in storage: inout Heroes) {
        if !hero.isLiked {
            storage.removeAll { $0.heroID == hero.heroID }
        } else {
            storage.append(hero)
        }
    }
    
    
}
