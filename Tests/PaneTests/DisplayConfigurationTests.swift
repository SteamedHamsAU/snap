import Testing
@testable import Pane

@Suite("DisplayConfiguration Model")
struct DisplayConfigurationTests {

    @Test("Encoding and decoding preserves all fields")
    func roundTrip() throws {
        let config = DisplayConfiguration(
            mode: .extend,
            extendPreset: .externalLeft,
            mirrorTarget: .macBook,
            rememberThisDisplay: true
        )

        let encoder = PropertyListEncoder()
        let data = try encoder.encode(config)

        let decoder = PropertyListDecoder()
        let decoded = try decoder.decode(DisplayConfiguration.self, from: data)

        #expect(decoded.mode == .extend)
        #expect(decoded.extendPreset == .externalLeft)
        #expect(decoded.mirrorTarget == .macBook)
        #expect(decoded.rememberThisDisplay == true)
    }

    @Test("Mirror mode round-trips correctly")
    func mirrorRoundTrip() throws {
        let config = DisplayConfiguration(
            mode: .mirror,
            extendPreset: .externalRight,
            mirrorTarget: .external,
            rememberThisDisplay: false
        )

        let data = try PropertyListEncoder().encode(config)
        let decoded = try PropertyListDecoder().decode(DisplayConfiguration.self, from: data)

        #expect(decoded.mode == .mirror)
        #expect(decoded.mirrorTarget == .external)
        #expect(decoded.rememberThisDisplay == false)
    }
}
