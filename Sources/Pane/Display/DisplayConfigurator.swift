import CoreGraphics

/// Applies display configurations using CGDisplay APIs.
///
/// All methods must be called from `@MainActor` (CGDisplay APIs are synchronous
/// and safe to call from the main thread).
@MainActor
enum DisplayConfigurator {

    /// Apply the given configuration to the external display.
    ///
    /// Wraps all changes in a `CGBeginDisplayConfiguration` / `CGCompleteDisplayConfiguration` transaction.
    /// See pane-spec Section 6 for full implementation details.
    static func apply(
        _ config: DisplayConfiguration,
        primaryID: CGDirectDisplayID,
        externalID: CGDirectDisplayID
    ) {
        // TODO: Phase 1 — Implementation per spec Section 6:
        // 1. CGBeginDisplayConfiguration
        // 2. switch on config.mode
        //    - .extend: unmirror, position based on preset
        //    - .mirror: CGConfigureDisplayMirrorOfDisplay
        // 3. CGCompleteDisplayConfiguration(.permanently)
    }
}
