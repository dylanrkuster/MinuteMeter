import XCTest
@testable import MinuteMeter

final class TimeMathTests: XCTestCase {
    func testTimeLeftSubtractsUsedFromLimit() {
        XCTAssertEqual(TimeMath.timeLeft(limitMinutes: 120, usedMinutes: 48), 72)
    }

    func testTimeLeftIsNeverNegative() {
        XCTAssertEqual(TimeMath.timeLeft(limitMinutes: 120, usedMinutes: 150), 0)
    }

    func testFormat() {
        XCTAssertEqual(TimeMath.format(minutes: 0), "0:00")
        XCTAssertEqual(TimeMath.format(minutes: 5), "0:05")
        XCTAssertEqual(TimeMath.format(minutes: 72), "1:12")
        XCTAssertEqual(TimeMath.format(minutes: 120), "2:00")
        XCTAssertEqual(TimeMath.format(minutes: 600), "10:00")
    }

    func testFormatClampsNegativeToZero() {
        XCTAssertEqual(TimeMath.format(minutes: -5), "0:00")
    }

    func testSpoken() {
        XCTAssertEqual(TimeMath.spoken(minutes: 72), "1 hour, 12 minutes")
        XCTAssertEqual(TimeMath.spoken(minutes: 120), "2 hours")
    }
}

final class DayKeyTests: XCTestCase {
    func testFormatsLocalCalendarDay() {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "America/New_York")!
        // 2026-09-29 03:30 UTC is still the 28th in New York.
        let date = ISO8601DateFormatter().date(from: "2026-09-29T03:30:00Z")!
        XCTAssertEqual(DayKey.string(for: date, calendar: calendar), "2026-09-28")
    }
}
