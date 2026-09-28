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

        let entry = try HistoryStore(fileURL: fileURL).entry(for: "2026-09-28")

        XCTAssertEqual(entry, DayEntry(minutesUsed: 48, limitMinutes: 120, lockedCount: 6))
    }

    func testMissingEntryIsNil() throws {
        let json = #"{"2026-09-27": {"minutesUsed": 48, "limitMinutes": 120, "lockedCount": 6}}"#
        try Data(json.utf8).write(to: fileURL)

        XCTAssertNil(try HistoryStore(fileURL: fileURL).entry(for: "2026-09-28"))
    }

    func testMissingFileIsEmptyHistory() throws {
        XCTAssertEqual(try HistoryStore(fileURL: fileURL).readAll(), [:])
    }

    func testUndecodableFileThrows() throws {
        try Data("not json".utf8).write(to: fileURL)

        XCTAssertThrowsError(try HistoryStore(fileURL: fileURL).readAll()) { error in
            guard case HistoryStore.ReadError.undecodable = error else {
                return XCTFail("Expected undecodable, got \(error)")
            }
        }
    }

    func testUnreadableFileThrows() throws {
        // A directory where the file should be can't be read as data.
        try FileManager.default.createDirectory(at: fileURL, withIntermediateDirectories: false)

        XCTAssertThrowsError(try HistoryStore(fileURL: fileURL).readAll()) { error in
            guard case HistoryStore.ReadError.unreadable = error else {
                return XCTFail("Expected unreadable, got \(error)")
            }
        }
    }

    func testNoContainerThrows() {
        XCTAssertThrowsError(try HistoryStore(fileURL: nil).readAll()) { error in
            guard case HistoryStore.ReadError.noContainer = error else {
                return XCTFail("Expected noContainer, got \(error)")
            }
        }
    }
}
