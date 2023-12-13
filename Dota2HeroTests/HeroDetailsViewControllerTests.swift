//
//  HeroDetailsViewControllerTests.swift
//  Dota2HeroTests
//
//  Created by Саша Восколович on 13.12.2023.
//

import XCTest
@testable import Dota2Hero


final class HeroDetailsViewControllerTests: XCTestCase {


    var factory: Factory!
    var heroManager: DataManager!
    var updaterAll: HeroesUpdater!
    var updaterLike: HeroesUpdater!
    
    
    override func setUp() {
        super.setUp()
        factory = LabelFactory()
        updaterAll = AllHeroesUpdater()
        updaterLike = LikedHeroesUpdater()
        heroManager = HeroesDataManager(updaterInAll: updaterAll, updaterInLiked: updaterLike)
    }
    
    override func tearDown() {
        factory = nil
        updaterAll = nil
        updaterLike = nil
        heroManager = nil
        super.tearDown()
    }
    
    
    
    
    func test_loading() {
        let sut = HeroDetailsViewController(factory: factory, heroesManager: heroManager)
        sut.loadViewIfNeeded()
        XCTAssertNotNil(sut)
        
    }

}
