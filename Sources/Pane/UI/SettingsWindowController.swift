import AppKit
import SwiftUI

/// Controls the settings window opened from the menu bar.
///
/// See pane-spec Section 10.
@MainActor
final class SettingsWindowController {

    private var window: NSWindow?

    /// Show the settings window.
    func show() {
        // TODO: Phase 4 — Create NSWindow hosting SettingsView:
        //   - Standard window with title "Pane Settings"
        //   - Resizable: false
        //   - Host SettingsView via NSHostingView
    }
}
