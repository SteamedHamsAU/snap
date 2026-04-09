import CoreGraphics
import Foundation

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
    private static let logger = SnapLogger(category: "DisplayConfigurator")

    /// Apply the given configuration to the external display.
    ///
    /// Wraps all changes in a `beginConfiguration` / `completeConfiguration` transaction
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
            // Always unmirror first (handles mirror → extend transition)
            transactor.configureMirror(cfg, display: externalID, primary: kCGNullDirectDisplay)

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

            transactor.configureOrigin(cfg, display: externalID, x: Int32(origin.x), y: Int32(origin.y))
            logger.info("Applying extend preset: \(config.extendPreset.rawValue)")

        case .mirror:
            switch config.mirrorTarget {
            case .macBook:
                transactor.configureMirror(cfg, display: externalID, primary: primaryID)
            case .external:
                transactor.configureMirror(cfg, display: primaryID, primary: externalID)
            }
            logger.info("Applying mirror target: \(config.mirrorTarget.rawValue)")
        }

        if transactor.completeConfiguration(cfg) {
            logger.info("Display configuration applied successfully")
        } else {
            logger.error("completeConfiguration failed")
        }
    }
}
