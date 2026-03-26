import Foundation

/// Persists display configurations keyed by display UUID.
///
/// Storage: `~/Library/Application Support/Snap/displays.plist`
@MainActor
final class DisplayConfigStore {
    private var configurations: [String: DisplayConfiguration] = [:]
    private let fileURL: URL
    private var persistTask: Task<Void, Never>?

    init() {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let snapDir = appSupport.appendingPathComponent("Snap", isDirectory: true)
        fileURL = snapDir.appendingPathComponent("displays.plist")

        // Ensure directory exists
        try? FileManager.default.createDirectory(at: snapDir, withIntermediateDirectories: true)

        // Load existing configurations
        load()
    }

    // MARK: - Public API

    func configuration(for uuid: String) -> DisplayConfiguration? {
        configurations[uuid]
    }

    func save(_ config: DisplayConfiguration, for uuid: String) {
        configurations[uuid] = config
        persist()
    }

    func remove(for uuid: String) {
        configurations.removeValue(forKey: uuid)
        persist()
    }

    func allEntries() -> [(uuid: String, config: DisplayConfiguration)] {
        configurations.map { (uuid: $0.key, config: $0.value) }
    }

    func removeAll() {
        configurations.removeAll()
        persist()
    }

    // MARK: - Private

    private func load() {
        guard let data = try? Data(contentsOf: fileURL) else { return }
        let decoder = PropertyListDecoder()
        configurations = (try? decoder.decode([String: DisplayConfiguration].self, from: data)) ?? [:]
    }

    private func persist() {
        // Cancel any pending write — we'll replace it with the latest snapshot.
        // The in-memory state is always mutated on the main actor before this is
        // called, so encoding here captures the definitive current state.
        persistTask?.cancel()
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        guard let data = try? encoder.encode(configurations) else { return }
        let url = fileURL
        persistTask = Task.detached(priority: .utility) {
            try? data.write(to: url, options: .atomic)
        }
    }
}
