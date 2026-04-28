import CoreGraphics
import Foundation
import os

// MARK: - DisplayTransacting

/// Abstracts CGDisplay configuration calls so `DisplayConfigurator` can be tested
/// without hitting real hardware.
@MainActor
protocol DisplayTransacting {
    func beginConfiguration() -> CGDisplayConfigRef?
    func configureOrigin(_ configRef: CGDisplayConfigRef, display: CGDirectDisplayID, x: Int32, y: Int32)
    func configureMirror(_ configRef: CGDisplayConfigRef, display: CGDirectDisplayID, primary: CGDirectDisplayID)
    func completeConfiguration(_ configRef: CGDisplayConfigRef) -> Bool
    func displayBounds(_ display: CGDirectDisplayID) -> CGRect
}

// MARK: - SystemDisplayTransactor

/// Production implementation that forwards to the real CGDisplay C API.
@MainActor
struct SystemDisplayTransactor: DisplayTransacting {
    func beginConfiguration() -> CGDisplayConfigRef? {
        var configRef: CGDisplayConfigRef?
        let status = CGBeginDisplayConfiguration(&configRef)
        guard status == .success else { return nil }
        return configRef
    }

    func configureOrigin(_ configRef: CGDisplayConfigRef, display: CGDirectDisplayID, x: Int32, y: Int32) {
        CGConfigureDisplayOrigin(configRef, display, x, y)
    }

    func configureMirror(_ configRef: CGDisplayConfigRef, display: CGDirectDisplayID, primary: CGDirectDisplayID) {
        CGConfigureDisplayMirrorOfDisplay(configRef, display, primary)
    }

    func completeConfiguration(_ configRef: CGDisplayConfigRef) -> Bool {
        CGCompleteDisplayConfiguration(configRef, .permanently) == .success
    }

    func displayBounds(_ display: CGDirectDisplayID) -> CGRect {
        CGDisplayBounds(display)
    }
}

// MARK: - DisplayConfigurator

/// Applies display configurations using CGDisplay APIs.
///
/// All methods must be called from `@MainActor` (CGDisplay APIs are synchronous
/// and safe to call from the main thread).
@MainActor
enum DisplayConfigurator {
    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "au.steamedhams.snap",
        category: "DisplayConfigurator"
    )

    /// Apply the given configuration to the external display.
    ///
    /// Wraps all changes in `beginConfiguration` / `completeConfiguration` transactions
    /// driven by the provided `transactor`. The default uses real CGDisplay APIs.
    static func apply(
        _ config: DisplayConfiguration,
        primaryID: CGDirectDisplayID,
        externalID: CGDirectDisplayID,
        transactor: DisplayTransacting = SystemDisplayTransactor()
    ) {
        guard let cfg = transactor.beginConfiguration() else {
            logger.error("beginConfiguration failed")
            return
        }

        switch config.mode {
        case .extend:
            applyExtend(config, cfg: cfg, primaryID: primaryID, externalID: externalID, transactor: transactor)
        case .mirror:
            applyMirror(config, cfg: cfg, primaryID: primaryID, externalID: externalID, transactor: transactor)
        }
    }

    // MARK: - Extend

    private static func applyExtend(
        _ config: DisplayConfiguration,
        cfg: CGDisplayConfigRef,
        primaryID: CGDirectDisplayID,
        externalID: CGDirectDisplayID,
        transactor: DisplayTransacting
    ) {
        // Transaction 1: unmirror (idempotent if not mirrored).
        // Must commit before reading bounds so they reflect the
        // independent (non-mirrored) display geometry.
        transactor.configureMirror(cfg, display: externalID, primary: kCGNullDirectDisplay)
        if !transactor.completeConfiguration(cfg) {
            logger.error("completeConfiguration failed (unmirror)")
            return
        }

        // Transaction 2: position using settled post-unmirror bounds
        guard let positionCfg = transactor.beginConfiguration() else {
            logger.error("beginConfiguration failed (position)")
            return
        }

        let internalBounds = transactor.displayBounds(primaryID)
        let externalBounds = transactor.displayBounds(externalID)
        let origin = switch config.extendPreset {
        case .externalRight:
            CGPoint(
                x: internalBounds.maxX,
                y: internalBounds.midY - externalBounds.height / 2
            )
        case .externalLeft:
            CGPoint(
                x: internalBounds.minX - externalBounds.width,
                y: internalBounds.midY - externalBounds.height / 2
            )
        case .externalAbove:
            CGPoint(
                x: internalBounds.midX - externalBounds.width / 2,
                y: internalBounds.minY - externalBounds.height
            )
        }

        transactor.configureOrigin(positionCfg, display: externalID, x: Int32(origin.x), y: Int32(origin.y))
        logger.info("Applying extend preset: \(config.extendPreset.rawValue)")

        if transactor.completeConfiguration(positionCfg) {
            logger.info("Display configuration applied successfully")
        } else {
            logger.error("completeConfiguration failed")
        }
    }

    // MARK: - Mirror

    private static func applyMirror(
        _ config: DisplayConfiguration,
        cfg: CGDisplayConfigRef,
        primaryID: CGDirectDisplayID,
        externalID: CGDirectDisplayID,
        transactor: DisplayTransacting
    ) {
        switch config.mirrorTarget {
        case .macBook:
            transactor.configureMirror(cfg, display: externalID, primary: primaryID)
        case .external:
            transactor.configureMirror(cfg, display: primaryID, primary: externalID)
        }
        logger.info("Applying mirror target: \(config.mirrorTarget.rawValue)")

        if transactor.completeConfiguration(cfg) {
            logger.info("Display configuration applied successfully")
        } else {
            logger.error("completeConfiguration failed")
        }
    }
}
