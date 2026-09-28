import XCTest
@testable import MinuteMeter

final class TodayModelTests: XCTestCase {
    private var fileURL: URL!
    private var now = ISO8601DateFormatter().date(from: "2026-09-28T15:00:00Z")!
    private var calendar = TodayModelTests.calendar(timeZone: "UTC")

    override func setUp() {
        fileURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("json")
    }

    override func tearDown() {
        try? FileManager.default.removeItem(at: fileURL)
    }

    private static func calendar(timeZone: String) -> Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: timeZone)!
        calendar.locale = Locale(identifier: "en_US_POSIX")
        return calendar
    }

    private func model() -> TodayModel {
        TodayModel(history: HistoryStore(fileURL: fileURL), now: { self.now }, calendar: { self.calendar })
    }

    private func writeHistory(_ json: String) throws {
        try Data(json.utf8).write(to: fileURL)
    }

    func testNoHistoryShowsFullLimit() {
        let model = model()

        XCTAssertEqual(model.limitMinutes, Limit.defaultMinutes)
        XCTAssertEqual(model.usedMinutes, 0)
        XCTAssertEqual(model.leftMinutes, Limit.defaultMinutes)
    }

    func testUsesTodaysEntry() throws {
        try writeHistory(#"{"2026-09-28": {"minutesUsed": 48, "limitMinutes": 120, "lockedCount": 6}}"#)

        XCTAssertEqual(model().leftMinutes, 72)
    }

    func testIgnoresOtherDays() throws {
        try writeHistory(#"{"2026-09-27": {"minutesUsed": 48, "limitMinutes": 120, "lockedCount": 6}}"#)

        XCTAssertEqual(model().leftMinutes, Limit.defaultMinutes)
    }

    func testUsesTheDaysOwnLimit() throws {
        try writeHistory(#"{"2026-09-28": {"minutesUsed": 10, "limitMinutes": 60, "lockedCount": 6}}"#)

        let model = model()

        XCTAssertEqual(model.limitMinutes, 60)
        XCTAssertEqual(model.leftMinutes, 50)
    }

    func testRefreshPicksUpNewHistory() throws {
        let model = model()
        try writeHistory(#"{"2026-09-28": {"minutesUsed": 30, "limitMinutes": 120, "lockedCount": 6}}"#)

        model.refresh()

        XCTAssertEqual(model.leftMinutes, 90)
    }

    func testReadFailureShowsUnknownInsteadOfFullLimit() throws {
        try writeHistory("not json")

        let model = model()

        XCTAssertNil(model.usedMinutes)
        XCTAssertNil(model.leftMinutes)
    }

    func testRollsOverAtMidnight() throws {
        try writeHistory(#"""
        {"2026-09-28": {"minutesUsed": 90, "limitMinutes": 120, "lockedCount": 6},
         "2026-09-29": {"minutesUsed": 30, "limitMinutes": 120, "lockedCount": 6}}
        """#)
        now = ISO8601DateFormatter().date(from: "2026-09-28T23:59:00Z")!
        let model = model()
        XCTAssertEqual(model.dateText, "Mon 28 Sep")
        XCTAssertEqual(model.leftMinutes, 30)

        now = ISO8601DateFormatter().date(from: "2026-09-29T00:01:00Z")!
        model.refresh()

        XCTAssertEqual(model.dateText, "Tue 29 Sep")
        XCTAssertEqual(model.leftMinutes, 90)
    }

    func testTimeZoneChangeSwitchesDayAndDate() throws {
        try writeHistory(#"""
        {"2026-09-28": {"minutesUsed": 90, "limitMinutes": 120, "lockedCount": 6},
         "2026-09-29": {"minutesUsed": 30, "limitMinutes": 120, "lockedCount": 6}}
        """#)
        // 03:30 UTC on the 29th is still the 28th in New York.
        now = ISO8601DateFormatter().date(from: "2026-09-29T03:30:00Z")!
        let model = model()
        XCTAssertEqual(model.dateText, "Tue 29 Sep")
        XCTAssertEqual(model.leftMinutes, 90)

        calendar = Self.calendar(timeZone: "America/New_York")
        model.refresh()

        XCTAssertEqual(model.dateText, "Mon 28 Sep")
        XCTAssertEqual(model.leftMinutes, 30)
    }

    func testTapeLabelsAreQuartersOfTheLimit() {
        XCTAssertEqual(TodayView.tapeLabels(limitMinutes: 120), ["0", "0:30", "1:00", "1:30", "2:00"])
    }
}
