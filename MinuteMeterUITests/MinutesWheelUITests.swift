import XCTest

/// Drives the minutes wheel in the real app and reads its VoiceOver value.
final class MinutesWheelUITests: XCTestCase {
    private var wheel: XCUIElement!

    override func setUpWithError() throws {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launch()
        wheel = app.descendants(matching: .any)["minutesWheel"]
        XCTAssertTrue(wheel.waitForExistence(timeout: 5))
    }

    func testOpensOn15AndScrollsBothWays() {
        XCTAssertEqual(settledMinutes(), 15)

        wheel.swipeUp(velocity: .slow)
        let afterUp = settledMinutes()
        XCTAssertGreaterThan(afterUp, 15)

        wheel.swipeDown(velocity: .slow)
        XCTAssertLessThan(settledMinutes(), afterUp)
    }

    func testStopsAt1And30() {
        // Several hard flings, more than enough to reach each end, so the
        // last ones push against the end and must not go past it.
        for _ in 1...3 { wheel.swipeDown(velocity: .fast) }
        XCTAssertEqual(settledMinutes(), 1)
        XCTAssertEqual(wheel.value as? String, "1 minute")

        for _ in 1...3 { wheel.swipeUp(velocity: .fast) }
        XCTAssertEqual(settledMinutes(), 30)
        XCTAssertEqual(wheel.value as? String, "30 minutes")
    }

    // MARK: - Helpers

    /// The wheel's value once it stops changing, read from its VoiceOver
    /// value ("15 minutes" or "1 minute"). Polls because a swipe keeps the
    /// wheel coasting after the gesture ends.
    private func settledMinutes(timeout: TimeInterval = 5) -> Int {
        var last = minutes()
        let deadline = Date().addingTimeInterval(timeout)
        while Date() < deadline {
            Thread.sleep(forTimeInterval: 0.4)
            let current = minutes()
            if current == last { return current }
            last = current
        }
        XCTFail("The wheel didn't settle within \(timeout) seconds")
        return last
    }

    private func minutes() -> Int {
        let value = wheel.value as? String ?? ""
        return Int(value.split(separator: " ").first ?? "") ?? -1
    }
}
