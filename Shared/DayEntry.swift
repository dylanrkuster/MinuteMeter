import Foundation

/// One day of history. There is at most one entry per calendar day.
struct DayEntry: Codable, Equatable {
    var minutesUsed: Int
    /// The limit that applied on this day.
    var limitMinutes: Int
    /// How many apps and categories were locked on this day.
    var lockedCount: Int
}

/// Identifies a calendar day as text, for example "2026-09-28".
///
/// History is keyed by this instead of a timestamp: a day means "this calendar
/// day where the user is", and turning a timestamp back into a day needs a time
/// zone. See issue #3.
enum DayKey {
    static func string(for date: Date, calendar: Calendar = .current) -> String {
        let parts = calendar.dateComponents([.year, .month, .day], from: date)
        return String(format: "%04d-%02d-%02d", parts.year ?? 0, parts.month ?? 0, parts.day ?? 0)
    }
}

/// The daily limit. Fixed until the limit becomes editable.
enum Limit {
    static let defaultMinutes = 120
}
