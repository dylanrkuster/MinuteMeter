import XCTest
@testable import MinuteMeter

final class HistoryStoreTests: XCTestCase {
    private var fileURL: URL!

    override func setUp() {
        fileURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("json")
    }

    override func tearDown() {
        try? FileManager.default.removeItem(at: fileURL)
    }

    func testReadsTodaysEntry() throws {
        let json = #"{"2026-09-28": {"minutesUsed": 48, "limitMinutes": 120, "lockedCount": 6}}"#
        try Data(json.utf8).write(to: fileURL)

        let entry = HistoryStore(fileURL: fileURL).entry(for: "2026-09-28")

        XCTAssertEqual(entry, DayEntry(minutesUsed: 48, limitMinutes: 120, lockedCount: 6))
    }

    func testMissingEntryIsNil() throws {
        let json = #"{"2026-09-27": {"minutesUsed": 48, "limitMinutes": 120, "lockedCount": 6}}"#
        try Data(json.utf8).write(to: fileURL)

        XCTAssertNil(HistoryStore(fileURL: fileURL).entry(for: "2026-09-28"))
    }

    func testMissingFileReadsAsEmpty() {
        XCTAssertEqual(HistoryStore(fileURL: fileURL).readAll(), [:])
    }

    func testUnreadableFileReadsAsEmpty() throws {
        try Data("not json".utf8).write(to: fileURL)

        XCTAssertEqual(HistoryStore(fileURL: fileURL).readAll(), [:])
    }

    func testNoContainerReadsAsEmpty() {
        XCTAssertEqual(HistoryStore(fileURL: nil).readAll(), [:])
    }
}
