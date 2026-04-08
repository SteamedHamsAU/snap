import Foundation
import os

/// Persists display configurations keyed by display UUID.
///
/// Storage: `~/Library/Application Support/Snap/displays.plist`
@MainActor
final class DisplayConfigStore {
    private var configurations: [String: DisplayConfiguration] = [:]
    private let fileURL: URL

    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "au.steamedhams.snap",
        category: "DisplayConfigStore"
    )

    convenience init() {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let snapDir = appSupport.appendingPathComponent("Snap", isDirectory: true)
        self.init(fileURL: snapDir.appendingPathComponent("displays.plist"))
    }

    init(fileURL: URL) {
        self.fileURL = fileURL

        let parentDir = fileURL.deletingLastPathComponent()
        do {
            try FileManager.default.createDirectory(at: parentDir, withIntermediateDirectories: true)
        } catch {
            Self.logger.error("Failed to create config directory: \(error)")
        }

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
        let data: Data
        do {
            data = try Data(contentsOf: fileURL)
        } catch let error as NSError where error.domain == NSCocoaErrorDomain && error.code == NSFileReadNoSuchFileError {
            // No file yet — first launch, not an error
            return
        } catch {
            Self.logger.error("Failed to read config file: \(error)")
            return
        }

        do {
            configurations = try PropertyListDecoder().decode(
                [String: DisplayConfiguration].self,
                from: data
            )
        } catch {
            Self.logger.error("Failed to decode config file: \(error)")
        }
    }

    private func persist() {
        do {
            let encoder = PropertyListEncoder()
            encoder.outputFormat = .xml
            let data = try encoder.encode(configurations)
            try data.write(to: fileURL, options: .atomic)
        } catch {
            Self.logger.error("Failed to persist config file: \(error)")
        }
    }
}
