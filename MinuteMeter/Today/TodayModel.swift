import Foundation
import Observation
import os

/// What the Today screen shows: the date, today's limit, and minutes used.
@Observable
final class TodayModel {
    /// The header date, for example "Mon 28 Sep". Built from the same calendar
    /// and moment as the history lookup, so the date shown and the data used
    /// always refer to the same day.
    private(set) var dateText = ""
    private(set) var limitMinutes = Limit.defaultMinutes
    /// `nil` when history couldn't be read, so the screen shows an unknown
    /// value instead of guessing.
    private(set) var usedMinutes: Int? = 0

    var leftMinutes: Int? {
        usedMinutes.map { TimeMath.timeLeft(limitMinutes: limitMinutes, usedMinutes: $0) }
    }

    @ObservationIgnored private let history: HistoryStore
    @ObservationIgnored private let now: () -> Date
    @ObservationIgnored private let calendar: () -> Calendar

    /// `now` and `calendar` are functions so tests can move the clock or change
    /// the time zone between refreshes. The default calendar follows the
    /// phone's current time zone.
    init(
        history: HistoryStore = .shared,
        now: @escaping () -> Date = Date.init,
        calendar: @escaping () -> Calendar = { .autoupdatingCurrent }
    ) {
        self.history = history
        self.now = now
        self.calendar = calendar
        refresh()
    }

    /// Re-reads today's entry. Until it exists, today counts as 0 used at the
    /// current limit.
    func refresh() {
        let date = now()
        let calendar = calendar()
        dateText = Self.dateText(for: date, calendar: calendar)
        do {
            let entry = try history.entry(for: DayKey.string(for: date, calendar: calendar))
            limitMinutes = entry?.limitMinutes ?? Limit.defaultMinutes
            usedMinutes = entry?.minutesUsed ?? 0
        } catch {
            Self.logger.error("Couldn't read history: \(String(describing: error), privacy: .public)")
            limitMinutes = Limit.defaultMinutes
            usedMinutes = nil
        }
    }

    private static func dateText(for date: Date, calendar: Calendar) -> String {
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.timeZone = calendar.timeZone
        formatter.locale = calendar.locale ?? .autoupdatingCurrent
        formatter.dateFormat = "EEE d MMM"
        return formatter.string(from: date)
    }

    private static let logger = Logger(subsystem: "com.dylankuster.MinuteMeter", category: "Today")
}
