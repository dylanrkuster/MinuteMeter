import XCTest
@testable import MinuteMeter

final class MinuteMeterTests: XCTestCase {
    func testAppGroupID() {
        XCTAssertEqual(AppGroup.id, "group.com.dylankuster.MinuteMeter")
    }
}
