import CoreGraphics
import IOKit

/// Delegate protocol for display connection events.
@MainActor
protocol DisplayMonitorDelegate: AnyObject {
    func displayDidConnect(
        id: CGDirectDisplayID,
        uuid: String,
        name: String,
        resolution: CGSize
    )
}

/// Registers for CGDisplay reconfiguration events and dispatches to delegate.
///
/// The CGDisplay callback arrives on an arbitrary thread — this class dispatches
/// all delegate calls to `@MainActor`.
final class DisplayMonitor {

    @MainActor weak var delegate: DisplayMonitorDelegate?

    init() {}

    /// Start listening for display configuration changes.
    func startMonitoring() {
        // TODO: Phase 1 — Register CGDisplayRegisterReconfigurationCallback
        // Pass `self` as userInfo via Unmanaged pointer.
        // In the callback, extract the monitor, call handleReconfiguration.
    }

    /// Stop listening for display configuration changes.
    func stopMonitoring() {
        // TODO: Phase 1 — CGDisplayRemoveReconfigurationCallback
    }

    // MARK: - Reconfiguration handler

    func handleReconfiguration(displayID: CGDirectDisplayID, flags: CGDisplayChangeSummaryFlags) {
        // TODO: Phase 1 — Implementation per spec Section 4:
        // - Only fire on addFlag
        // - Ignore built-in and mirrored displays
        // - Extract UUID and name
        // - Dispatch to delegate on MainActor
    }

    // MARK: - Display helpers

    /// Returns a persistent UUID string for the given display.
    func displayUUID(for displayID: CGDirectDisplayID) -> String {
        // TODO: Phase 1 — CGDisplayCreateUUIDRef → CFUUIDCreateString
        return "unknown-\(displayID)"
    }

    /// Returns the human-readable product name via IOKit.
    func displayName(for displayID: CGDirectDisplayID) -> String {
        // TODO: Phase 1 — Query IODisplayConnect for DisplayProductName
        return "External Display"
    }
}
