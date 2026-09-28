import XCTest

final class TodayUITests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
    }

    func testShowsTimeLeftOnLaunch() {
        let app = XCUIApplication()
        app.launch()

        let timeLeft = app.staticTexts["timeLeft"]
        XCTAssertTrue(timeLeft.waitForExistence(timeout: 5))
        // No history exists yet, so the full 2-hour limit is left.
        XCTAssertEqual(timeLeft.value as? String, "2 hours")
    }
}
