import Foundation

/// Model representing a saved display arrangement configuration.
struct DisplayConfiguration: Codable {
    enum Mode: String, Codable {
        case extend
        case mirror
    }

    enum ExtendPreset: String, Codable, CaseIterable {
        case externalRight
        case externalLeft
        case externalAbove
    }

    enum MirrorTarget: String, Codable, CaseIterable {
        case macBook
        case external
    }

    var mode: Mode
    var extendPreset: ExtendPreset
    var mirrorTarget: MirrorTarget
    var rememberThisDisplay: Bool
    /// Human-readable display name (e.g. "LG UltraWide"). Optional for backwards compat with older plists.
    var displayName: String?
    /// Native resolution width. Optional for backwards compat.
    var resolutionWidth: Int?
    /// Native resolution height. Optional for backwards compat.
    var resolutionHeight: Int?
    /// Display diagonal size in inches (e.g. 27). Optional for backwards compat.
    var screenSizeInches: Int?
    /// Timestamp of the most recent connection event. Optional for backwards compat.
    var lastConnected: Date?
}

// MARK: - Display-friendly labels

extension DisplayConfiguration.ExtendPreset {
    var displayName: String {
        switch self {
        case .externalRight: "Right"
        case .externalLeft: "Left"
        case .externalAbove: "Above"
        }
    }
}

extension DisplayConfiguration.MirrorTarget {
    var displayName: String {
        switch self {
        case .macBook: "Optimise for MacBook"
        case .external: "Optimise for external"
        }
    }
}

extension DisplayConfiguration.Mode {
    var displayName: String {
        switch self {
        case .extend: "Extend"
        case .mirror: "Mirror"
        }
    }
}
