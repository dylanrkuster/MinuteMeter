import Foundation

/// Minute arithmetic and formatting shared by the app and its extensions.
/// All durations are whole minutes.
enum TimeMath {
    /// Minutes left today. Never negative, even if more was used than allowed.
    static func timeLeft(limitMinutes: Int, usedMinutes: Int) -> Int {
        max(0, limitMinutes - usedMinutes)
    }

    /// Formats minutes as `h:mm`, for example 72 → "1:12".
    static func format(minutes: Int) -> String {
        let minutes = max(0, minutes)
        return "\(minutes / 60):" + String(format: "%02d", minutes % 60)
    }

    /// Spoken form for VoiceOver, for example 72 → "1 hour, 12 minutes".
    static func spoken(minutes: Int) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .full
        formatter.zeroFormattingBehavior = .dropAll
        return formatter.string(from: TimeInterval(max(0, minutes) * 60)) ?? ""
    }
}
