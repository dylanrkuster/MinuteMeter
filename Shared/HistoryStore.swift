import Foundation

/// Reads the daily history file, `history.json` in the App Group.
///
/// The file holds a dictionary from day key (see `DayKey`) to `DayEntry`, so
/// there can only be one entry per day and today's entry is a direct lookup.
///
/// Reads go through `NSFileCoordinator` because the app and its extensions run
/// in separate processes and will write this file.
///
/// A missing file is normal: it means there's no history yet. Every other
/// failure throws, so nothing built on a read can mistake a broken file for an
/// empty one and, for example, save over it.
struct HistoryStore {
    enum ReadError: Error {
        /// The App Group container isn't available, so there's nowhere to read from.
        case noContainer
        case coordination(Error)
        case unreadable(Error)
        case undecodable(Error)
    }

    /// `nil` when the App Group container isn't available.
    let fileURL: URL?

    static let shared = HistoryStore(
        fileURL: FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: AppGroup.id)?
            .appendingPathComponent("history.json")
    )

    /// The entry for `day`, or `nil` if there isn't one yet.
    func entry(for day: String) throws -> DayEntry? {
        try readAll()[day]
    }

    /// Every entry. Empty only when the file doesn't exist yet.
    func readAll() throws -> [String: DayEntry] {
        guard let fileURL else { throw ReadError.noContainer }
        guard let data = try coordinatedRead(fileURL) else { return [:] }
        do {
            return try JSONDecoder().decode([String: DayEntry].self, from: data)
        } catch {
            throw ReadError.undecodable(error)
        }
    }

    /// The file's contents, or `nil` if it doesn't exist.
    private func coordinatedRead(_ url: URL) throws -> Data? {
        var result: Result<Data?, Error> = .success(nil)
        var coordinationError: NSError?
        NSFileCoordinator().coordinate(readingItemAt: url, options: [], error: &coordinationError) { url in
            do {
                result = .success(try Data(contentsOf: url))
            } catch CocoaError.fileReadNoSuchFile {
                result = .success(nil)
            } catch {
                result = .failure(ReadError.unreadable(error))
            }
        }
        if let coordinationError { throw ReadError.coordination(coordinationError) }
        return try result.get()
    }
}
