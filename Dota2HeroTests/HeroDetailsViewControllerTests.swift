//
//  HeroDetailsViewControllerTests.swift
//  Dota2HeroTests
//
//  Created by Саша Восколович on 13.12.2023.
//

import XCTest
@testable import Dota2Hero


final class HeroDetailsViewControllerTests: XCTestCase {

    func test_loading() {
        let sut = HeroDetailsViewController(factory: LabelFactory(), heroesManager: HeroesDataManager(updaterInAll: AllHeroesUpdater(), updaterInLiked: LikedHeroesUpdater()))
        sut.loadViewIfNeeded()
        sut.viewDidAppear(false)
        XCTAssertNotNil(sut)
    }
    
    func test_buttonTapped_ShouldBeTrue() {
        let sut = HeroDetailsViewController(factory: LabelFactory(), heroesManager: HeroesDataManager(updaterInAll: AllHeroesUpdater(), updaterInLiked: LikedHeroesUpdater()))
        
        sut.loadViewIfNeeded()
        
        tap(sut.likedButton)
        XCTAssertTrue(sut.likedButton.isSelected)
    }
    
}

