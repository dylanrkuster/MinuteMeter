import Foundation
import Observation

/// What the Today screen shows: the date, today's limit, and minutes used.
@Observable
final class TodayModel {
    private(set) var today: Date
    private(set) var limitMinutes = Limit.defaultMinutes
    private(set) var usedMinutes = 0

    var leftMinutes: Int {
        TimeMath.timeLeft(limitMinutes: limitMinutes, usedMinutes: usedMinutes)
    }

    @ObservationIgnored private let history: HistoryStore
    @ObservationIgnored private let now: () -> Date
    @ObservationIgnored private let calendar: Calendar

    /// `now` and `calendar` are passed in so tests can pick the day.
    init(
        history: HistoryStore = .shared,
        now: @escaping () -> Date = Date.init,
        calendar: Calendar = .current
    ) {
        self.history = history
        self.now = now
        self.calendar = calendar
        self.today = now()
        refresh()
    }

    /// Re-reads today's entry. Until it exists, today counts as 0 used at the
    /// current limit.
    func refresh() {
        let date = now()
        let entry = history.entry(for: DayKey.string(for: date, calendar: calendar))
        today = date
        limitMinutes = entry?.limitMinutes ?? Limit.defaultMinutes
        usedMinutes = entry?.minutesUsed ?? 0
    }
}
