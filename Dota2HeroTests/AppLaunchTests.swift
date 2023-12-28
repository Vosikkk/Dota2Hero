//
//  AppLaunchTests.swift
//  Dota2HeroTests
//
//  Created by Саша Восколович on 12.12.2023.
//

import XCTest

final class AppLaunchTests: XCTestCase {

    
    func test_DidFinishLaunching_ShouldBeTrue() {
        let sut = TestingAppDelegate()
        let didFinishLaunching = sut.application(UIApplication.shared, didFinishLaunchingWithOptions: nil)
        XCTAssertTrue(didFinishLaunching)
    }

}
