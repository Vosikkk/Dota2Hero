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
    
    func test_tappingImageOnLikedViewController_shouldPushHeroDetailsViewController() {
        let sut = LikedHeroesViewController(heroesManager: HeroesDataManager(updaterInAll: AllHeroesUpdater(), updaterInLiked: LikedHeroesUpdater()), fetcher: Fetcher(heroFetcher: HeroFetcher(), imageFetcher: ImageFetcher(cache: ImageCache())), factory: LabelFactory())
        
        let navigation = UINavigationController(rootViewController: sut)
        
        sut.didTapOnImageHeroView(heroID: 0)
        executeRunLoop()
        
        XCTAssertEqual(navigation.viewControllers.count, 2, "navigation stack")
        
        let pushedVC = navigation.viewControllers.last
        
        guard let detailsVC = pushedVC as? HeroDetailsViewController else {
            XCTFail("Expected HeroDetailsViewController + but was \(String(describing: pushedVC))")
            return
        }
        
        XCTAssertEqual(detailsVC.moveSpeedLabel.text, "Test sending info to the controller")
        
    }
}

