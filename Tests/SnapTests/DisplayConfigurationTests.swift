import Foundation
@testable import Snap
import Testing

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

    // MARK: - Mode

    struct ModeTests {
        @Test("extend encodes and decodes correctly")
        func extendRoundTrip() throws {
            let config = DisplayConfiguration(
                mode: .extend,
                extendPreset: .externalRight,
                mirrorTarget: .macBook,
                rememberThisDisplay: true
            )
            let data = try PropertyListEncoder().encode(config)
            let decoded = try PropertyListDecoder().decode(DisplayConfiguration.self, from: data)
            #expect(decoded.mode == .extend)
        }

        @Test("mirror encodes and decodes correctly")
        func mirrorRoundTrip() throws {
            let config = DisplayConfiguration(
                mode: .mirror,
                extendPreset: .externalRight,
                mirrorTarget: .macBook,
                rememberThisDisplay: true
            )
            let data = try PropertyListEncoder().encode(config)
            let decoded = try PropertyListDecoder().decode(DisplayConfiguration.self, from: data)
            #expect(decoded.mode == .mirror)
        }

        @Test("displayName returns expected strings")
        func displayNames() {
            #expect(DisplayConfiguration.Mode.extend.displayName == "Extend")
            #expect(DisplayConfiguration.Mode.mirror.displayName == "Mirror")
        }
    }

    // MARK: - ExtendPreset

    struct ExtendPresetTests {
        @Test("all values encode and decode correctly", arguments: DisplayConfiguration.ExtendPreset.allCases)
        func encodeDecode(_ preset: DisplayConfiguration.ExtendPreset) throws {
            let config = DisplayConfiguration(
                mode: .extend,
                extendPreset: preset,
                mirrorTarget: .macBook,
                rememberThisDisplay: true
            )
            let data = try PropertyListEncoder().encode(config)
            let decoded = try PropertyListDecoder().decode(DisplayConfiguration.self, from: data)
            #expect(decoded.extendPreset == preset)
        }

        @Test("displayName returns expected strings")
        func displayNames() {
            #expect(DisplayConfiguration.ExtendPreset.externalRight.displayName == "Right")
            #expect(DisplayConfiguration.ExtendPreset.externalLeft.displayName == "Left")
            #expect(DisplayConfiguration.ExtendPreset.externalAbove.displayName == "Above")
        }

        @Test("CaseIterable returns all cases")
        func allCases() {
            let cases = DisplayConfiguration.ExtendPreset.allCases
            #expect(cases.count == 3)
            #expect(cases.contains(.externalRight))
            #expect(cases.contains(.externalLeft))
            #expect(cases.contains(.externalAbove))
        }
    }

    // MARK: - MirrorTarget

    struct MirrorTargetTests {
        @Test("all values encode and decode correctly", arguments: DisplayConfiguration.MirrorTarget.allCases)
        func encodeDecode(_ target: DisplayConfiguration.MirrorTarget) throws {
            let config = DisplayConfiguration(
                mode: .mirror,
                extendPreset: .externalRight,
                mirrorTarget: target,
                rememberThisDisplay: true
            )
            let data = try PropertyListEncoder().encode(config)
            let decoded = try PropertyListDecoder().decode(DisplayConfiguration.self, from: data)
            #expect(decoded.mirrorTarget == target)
        }

        @Test("displayName returns expected strings")
        func displayNames() {
            #expect(DisplayConfiguration.MirrorTarget.macBook.displayName == "Optimise for MacBook")
            #expect(DisplayConfiguration.MirrorTarget.external.displayName == "Optimise for external")
        }

        @Test("CaseIterable returns all cases")
        func allCases() {
            let cases = DisplayConfiguration.MirrorTarget.allCases
            #expect(cases.count == 2)
            #expect(cases.contains(.macBook))
            #expect(cases.contains(.external))
        }
    }

    // MARK: - rememberThisDisplay

    @Test("rememberThisDisplay true round-trips correctly")
    func rememberThisDisplayTrue() throws {
        let config = DisplayConfiguration(
            mode: .extend,
            extendPreset: .externalRight,
            mirrorTarget: .macBook,
            rememberThisDisplay: true
        )
        let data = try PropertyListEncoder().encode(config)
        let decoded = try PropertyListDecoder().decode(DisplayConfiguration.self, from: data)
        #expect(decoded.rememberThisDisplay == true)
    }

    @Test("rememberThisDisplay false round-trips correctly")
    func rememberThisDisplayFalse() throws {
        let config = DisplayConfiguration(
            mode: .extend,
            extendPreset: .externalRight,
            mirrorTarget: .macBook,
            rememberThisDisplay: false
        )
        let data = try PropertyListEncoder().encode(config)
        let decoded = try PropertyListDecoder().decode(DisplayConfiguration.self, from: data)
        #expect(decoded.rememberThisDisplay == false)
    }

    // MARK: - Backwards Compatibility

    @Test("Decoding plist without optional fields succeeds with nils")
    func decodeWithoutOptionalFields() throws {
        let dict: [String: Any] = [
            "mode": "extend",
            "extendPreset": "externalRight",
            "mirrorTarget": "macBook",
            "rememberThisDisplay": true,
        ]
        let data = try PropertyListSerialization.data(fromPropertyList: dict, format: .xml, options: 0)
        let decoded = try PropertyListDecoder().decode(DisplayConfiguration.self, from: data)

        #expect(decoded.mode == .extend)
        #expect(decoded.extendPreset == .externalRight)
        #expect(decoded.mirrorTarget == .macBook)
        #expect(decoded.rememberThisDisplay == true)
        #expect(decoded.displayName == nil)
        #expect(decoded.resolutionWidth == nil)
        #expect(decoded.resolutionHeight == nil)
        #expect(decoded.screenSizeInches == nil)
        #expect(decoded.lastConnected == nil)
    }

    @Test("Round-trip preserves all optional fields when populated")
    func roundTripAllOptionalFields() throws {
        let now = Date()
        let config = DisplayConfiguration(
            mode: .extend,
            extendPreset: .externalLeft,
            mirrorTarget: .external,
            rememberThisDisplay: false,
            displayName: "DELL U2723QE",
            resolutionWidth: 3840,
            resolutionHeight: 2160,
            screenSizeInches: 27,
            lastConnected: now
        )
        let data = try PropertyListEncoder().encode(config)
        let decoded = try PropertyListDecoder().decode(DisplayConfiguration.self, from: data)

        #expect(decoded.displayName == "DELL U2723QE")
        #expect(decoded.resolutionWidth == 3840)
        #expect(decoded.resolutionHeight == 2160)
        #expect(decoded.screenSizeInches == 27)
        #expect(decoded.lastConnected != nil)
        let delta = try abs(#require(decoded.lastConnected?.timeIntervalSince(now)))
        #expect(delta < 1, "lastConnected should round-trip within 1s")
    }

    @Test("Round-trip with partial optional fields preserves set values and keeps others nil")
    func roundTripPartialOptionalFields() throws {
        let config = DisplayConfiguration(
            mode: .mirror,
            extendPreset: .externalAbove,
            mirrorTarget: .macBook,
            rememberThisDisplay: true,
            displayName: "LG 5K",
            screenSizeInches: 27
        )
        let data = try PropertyListEncoder().encode(config)
        let decoded = try PropertyListDecoder().decode(DisplayConfiguration.self, from: data)

        #expect(decoded.displayName == "LG 5K")
        #expect(decoded.screenSizeInches == 27)
        #expect(decoded.resolutionWidth == nil)
        #expect(decoded.resolutionHeight == nil)
    }
}
