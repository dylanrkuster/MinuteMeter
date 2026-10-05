import CoreGraphics
import Testing
@testable import MinuteMeter

/// The wheel must always come to rest on a whole row, never between two.
struct RowSnappingTests {
    let rowHeight: CGFloat = 54

    @Test func roundsDownJustUnderHalfARow() {
        let snapped = RowSnapping.snappedOffset(rowHeight * 3 + 26, rowHeight: rowHeight)
        #expect(snapped == rowHeight * 3)
    }

    @Test func roundsUpJustOverHalfARow() {
        let snapped = RowSnapping.snappedOffset(rowHeight * 3 + 28, rowHeight: rowHeight)
        #expect(snapped == rowHeight * 4)
    }

    @Test func leavesAnOffsetOnARowUnchanged() {
        let snapped = RowSnapping.snappedOffset(rowHeight * 3, rowHeight: rowHeight)
        #expect(snapped == rowHeight * 3)
    }
}
