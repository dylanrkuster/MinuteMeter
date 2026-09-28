import Foundation

/// Reads the daily history file, `history.json` in the App Group.
///
/// The file holds a dictionary from day key (see `DayKey`) to `DayEntry`, so
/// there can only be one entry per day and today's entry is a direct lookup.
///
/// Reads go through `NSFileCoordinator` because the app and its extensions run
/// in separate processes and will write this file.
struct HistoryStore {
    /// `nil` when the App Group container isn't available, such as in an
    /// unsigned build. The store then behaves as if there's no history.
    let fileURL: URL?

    static let shared = HistoryStore(
        fileURL: FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: AppGroup.id)?
            .appendingPathComponent("history.json")
    )

    /// The entry for `day`, or `nil` if there isn't one yet.
    func entry(for day: String) -> DayEntry? {
        readAll()[day]
    }

    /// Every entry. Empty if the file is missing or can't be decoded.
    func readAll() -> [String: DayEntry] {
        guard let fileURL, let data = coordinatedRead(fileURL) else { return [:] }
        return (try? JSONDecoder().decode([String: DayEntry].self, from: data)) ?? [:]
    }

    private func coordinatedRead(_ url: URL) -> Data? {
        var data: Data?
        var error: NSError?
        NSFileCoordinator().coordinate(readingItemAt: url, options: [], error: &error) { url in
            data = try? Data(contentsOf: url)
        }
        return data
    }
}
