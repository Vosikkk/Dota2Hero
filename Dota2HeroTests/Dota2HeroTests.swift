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
    var sut2: HeroesUpdater!
    
    var heroesAll: Heroes = [Dota2HeroModel(name: "", localizedName: "", primaryAttr: "", attackType: "", roles: [], img: "", baseMana: 0.0, baseHealth: 0.0, baseManaRegen: 0.0, baseHealthRegen: 0.0, baseAttackMin: 0.0, baseAttackMax: 0.0, attackRange: 0.0, attackSpeed: 0.0, moveSpeed: 0.0, baseStr: 0.0, baseAgi: 0.0, baseInt: 0.0, agiGain: 0.0, intGain: 0.0, strGain: 0.0, heroID: 0)]
    
    var model: Dota2HeroModel = Dota2HeroModel(name: "", localizedName: "", primaryAttr: "", attackType: "", roles: [], img: "", baseMana: 0.0, baseHealth: 0.0, baseManaRegen: 0.0, baseHealthRegen: 0.0, baseAttackMin: 0.0, baseAttackMax: 0.0, attackRange: 0.0, attackSpeed: 0.0, moveSpeed: 0.0, baseStr: 0.0, baseAgi: 0.0, baseInt: 0.0, agiGain: 0.0, intGain: 0.0, strGain: 0.0, heroID: 0)
  
    
    
    override func setUp() {
        super.setUp()
        sut = AllHeroesUpdater()
        sut2 = LikedHeroesUpdater()
    }
    
    override func tearDown() {
        sut = nil
        sut2 = nil
        super.tearDown()
    }
    
    func test_changesLikeState_inAllHeroesStorage_ShouldBeLiked() {
    
        model.isLiked = true
        
        XCTAssertFalse(heroesAll[0].isLiked)
        
        sut.update(model, in: &heroesAll)
        
        XCTAssertEqual(true, heroesAll[0].isLiked)
    }
    
    func test_changesLikeState_inAllHeroesStorage_ShouldBeDisLiked() {
        
        model.isLiked = false
        
        heroesAll[0].isLiked = true
        
        XCTAssertTrue(heroesAll[0].isLiked)
        
        sut.update(model, in: &heroesAll)
        
        XCTAssertEqual(false, heroesAll[0].isLiked)
        
    }
    
    func test_addLikedHero_inLikedStorage_ShouldBeSize1() {
        
        var storage: Heroes = []
        
        model.isLiked = true
        
        sut2.update(model, in: &storage)
        
        XCTAssertEqual(storage.count, 1)
        
    }
    
    func test_deleteLikedHero_inLikedStorage_ShouldBeSize0() {
        
        model.isLiked = false
        
        var storage: Heroes = [model]
        
        XCTAssertEqual(storage.count, 1)
        
        sut2.update(model, in: &storage)
        
        XCTAssertEqual(storage.count, 0)
        
    }
}

