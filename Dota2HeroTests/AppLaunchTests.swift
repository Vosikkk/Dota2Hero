//
//  AppLaunchTests.swift
//  Dota2HeroTests
//
//  Created by Саша Восколович on 12.12.2023.
//

import XCTest

final class AppLaunchTests: XCTestCase {

   
    var sut: TestingAppDelegate!
    
    override func setUp() {
        super.setUp()
        sut = TestingAppDelegate()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    
    func test_DidFinishLaunching_ShouldBeTrue() {
        let didFinishLaunching = sut.application(UIApplication.shared, didFinishLaunchingWithOptions: nil)
        XCTAssertTrue(didFinishLaunching)
    }

}
