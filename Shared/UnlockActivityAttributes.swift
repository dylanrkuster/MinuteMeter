import ActivityKit
import Foundation

/// The unlock countdown shown as a Live Activity. Shared by the app, which
/// starts it, and the LiveActivity extension, which draws it.
struct UnlockActivityAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {}

    var start: Date
    var end: Date
}
