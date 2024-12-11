//
//  Assignment4_PokeCatch_ExplorerUITestsLaunchTests.swift
//  Assignment4_PokeCatch-ExplorerUITests
//
//  Created by user on 2024-12-10.
//

import XCTest

final class Assignment4_PokeCatch_ExplorerUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
