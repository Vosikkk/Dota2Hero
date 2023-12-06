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
    
    override func setUp() {
        super.setUp()
        sut = AllHeroesUpdater()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_changesLikeState_inAllHeroesStorage() {
        
        model.isLiked = true
        
        XCTAssertFalse(heroesAll[0].isLiked)
        
        sut.update(model, in: &heroesAll)
        
        XCTAssertTrue(heroesAll[0].isLiked)
    }
}

