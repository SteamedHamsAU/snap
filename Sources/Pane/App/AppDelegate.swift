import AppKit
import Sparkle

/// Central coordinator: sets up menu bar, display monitoring, and Sparkle updates.
@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {

    private var menuBarController: MenuBarController?
    private var displayMonitor: DisplayMonitor?
    private let configStore = DisplayConfigStore()
    private let updaterController = SPUStandardUpdaterController(
        startingUpdater: true,
        updaterDelegate: nil,
        userDriverDelegate: nil
    )

    func applicationDidFinishLaunching(_ notification: Notification) {
        // TODO: Phase 1 — Initialise DisplayMonitor and wire delegate
        // TODO: Phase 3 — Initialise MenuBarController
        // TODO: Phase 4 — Register launch-at-login on first launch
    }
}

// MARK: - DisplayMonitorDelegate

extension AppDelegate: DisplayMonitorDelegate {
    func displayDidConnect(
        id: CGDirectDisplayID,
        uuid: String,
        name: String,
        resolution: CGSize
    ) {
        // TODO: Phase 1 — Look up UUID in configStore
        // If known: apply config silently, show toast
        // If unknown: show PromptWindow
    }
}
