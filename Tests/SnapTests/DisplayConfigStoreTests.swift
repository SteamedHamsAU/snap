@testable import Snap
import Foundation
import Testing

@MainActor
struct DisplayConfigStoreTests {
    // MARK: - Helpers

    private func makeTempFileURL() -> URL {
        let dir = FileManager.default.temporaryDirectory
            .appendingPathComponent("SnapTests-\(UUID().uuidString)", isDirectory: true)
        return dir.appendingPathComponent("displays.plist")
    }

    private func cleanup(_ url: URL) {
        let dir = url.deletingLastPathComponent()
        try? FileManager.default.removeItem(at: dir)
    }

    private func makeConfig(
        mode: DisplayConfiguration.Mode = .extend,
        preset: DisplayConfiguration.ExtendPreset = .externalRight,
        mirror: DisplayConfiguration.MirrorTarget = .macBook,
        remember: Bool = true
    ) -> DisplayConfiguration {
        DisplayConfiguration(
            mode: mode,
            extendPreset: preset,
            mirrorTarget: mirror,
            rememberThisDisplay: remember
        )
    }

    // MARK: - Tests

    @Test("New store returns nil for unknown UUID")
    func emptyStoreReturnsNil() {
        let url = makeTempFileURL()
        defer { cleanup(url) }

        let store = DisplayConfigStore(fileURL: url)
        #expect(store.configuration(for: "nonexistent") == nil)
    }

    @Test("Save and retrieve preserves all fields")
    func saveAndRetrieve() {
        let url = makeTempFileURL()
        defer { cleanup(url) }

        let store = DisplayConfigStore(fileURL: url)
        let config = makeConfig(mode: .mirror, preset: .externalLeft, mirror: .external, remember: false)
        let uuid = "test-uuid-1"

        store.save(config, for: uuid)
        let retrieved = store.configuration(for: uuid)

        #expect(retrieved != nil)
        #expect(retrieved?.mode == .mirror)
        #expect(retrieved?.extendPreset == .externalLeft)
        #expect(retrieved?.mirrorTarget == .external)
        #expect(retrieved?.rememberThisDisplay == false)
    }

    @Test("Save overwrites previous config for same UUID")
    func saveOverwrites() {
        let url = makeTempFileURL()
        defer { cleanup(url) }

        let store = DisplayConfigStore(fileURL: url)
        let uuid = "overwrite-uuid"

        store.save(makeConfig(mode: .extend), for: uuid)
        store.save(makeConfig(mode: .mirror, preset: .externalAbove, mirror: .external, remember: false), for: uuid)

        let retrieved = store.configuration(for: uuid)
        #expect(retrieved?.mode == .mirror)
        #expect(retrieved?.extendPreset == .externalAbove)
        #expect(retrieved?.mirrorTarget == .external)
        #expect(retrieved?.rememberThisDisplay == false)
    }

    @Test("Remove deletes only the specified UUID")
    func removeSpecificUUID() {
        let url = makeTempFileURL()
        defer { cleanup(url) }

        let store = DisplayConfigStore(fileURL: url)
        store.save(makeConfig(), for: "uuid-1")
        store.save(makeConfig(), for: "uuid-2")

        store.remove(for: "uuid-1")

        #expect(store.configuration(for: "uuid-1") == nil)
        #expect(store.configuration(for: "uuid-2") != nil)
    }

    @Test("RemoveAll clears all entries")
    func removeAll() {
        let url = makeTempFileURL()
        defer { cleanup(url) }

        let store = DisplayConfigStore(fileURL: url)
        store.save(makeConfig(), for: "a")
        store.save(makeConfig(), for: "b")
        store.save(makeConfig(), for: "c")

        store.removeAll()

        #expect(store.allEntries().isEmpty)
    }

    @Test("AllEntries returns all saved configs")
    func allEntries() {
        let url = makeTempFileURL()
        defer { cleanup(url) }

        let store = DisplayConfigStore(fileURL: url)
        store.save(makeConfig(mode: .extend), for: "uuid-1")
        store.save(makeConfig(mode: .mirror), for: "uuid-2")
        store.save(makeConfig(preset: .externalAbove), for: "uuid-3")

        let entries = store.allEntries()
        let uuids = Set(entries.map(\.uuid))

        #expect(entries.count == 3)
        #expect(uuids == Set(["uuid-1", "uuid-2", "uuid-3"]))
    }

    @Test("Data persists across separate store instances")
    func persistenceAcrossInstances() {
        let url = makeTempFileURL()
        defer { cleanup(url) }

        let store1 = DisplayConfigStore(fileURL: url)
        store1.save(makeConfig(mode: .mirror, preset: .externalLeft), for: "persist-uuid")

        let store2 = DisplayConfigStore(fileURL: url)
        let retrieved = store2.configuration(for: "persist-uuid")

        #expect(retrieved != nil)
        #expect(retrieved?.mode == .mirror)
        #expect(retrieved?.extendPreset == .externalLeft)
    }

    @Test("Corrupted plist does not crash, yields empty store")
    func corruptedPlist() throws {
        let url = makeTempFileURL()
        defer { cleanup(url) }

        let dir = url.deletingLastPathComponent()
        try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        try Data("not a valid plist at all!!!".utf8).write(to: url)

        let store = DisplayConfigStore(fileURL: url)

        #expect(store.configuration(for: "anything") == nil)
        #expect(store.allEntries().isEmpty)
    }

    @Test("Missing file is not an error — creates empty store")
    func missingFileIsNotError() {
        let url = makeTempFileURL()
        defer { cleanup(url) }

        // File does not exist yet
        #expect(!FileManager.default.fileExists(atPath: url.path))

        let store = DisplayConfigStore(fileURL: url)
        #expect(store.allEntries().isEmpty)
    }

    @Test("Optional fields are preserved through save/retrieve")
    func optionalFieldsPreserved() {
        let url = makeTempFileURL()
        defer { cleanup(url) }

        var config = makeConfig()
        config.displayName = "LG UltraWide"
        config.resolutionWidth = 3440
        config.resolutionHeight = 1440
        config.screenSizeInches = 34

        let store = DisplayConfigStore(fileURL: url)
        store.save(config, for: "optional-uuid")

        let retrieved = store.configuration(for: "optional-uuid")
        #expect(retrieved?.displayName == "LG UltraWide")
        #expect(retrieved?.resolutionWidth == 3440)
        #expect(retrieved?.resolutionHeight == 1440)
        #expect(retrieved?.screenSizeInches == 34)
    }
}
