import AppKit
import SwiftUI

/// Controls the prompt panel that appears when an unknown display connects.
///
/// Uses `NSPanel` with `nonactivatingPanel` style so it appears without
/// stealing focus from the current app. See pane-spec Section 7.
@MainActor
final class PromptWindowController {

    private var panel: NSPanel?

    /// Show the prompt for a newly connected display.
    func show(
        displayID: CGDirectDisplayID,
        uuid: String,
        name: String,
        resolution: CGSize,
        onApply: @escaping (DisplayConfiguration) -> Void,
        onDismiss: @escaping () -> Void
    ) {
        // TODO: Phase 2 — Create NSPanel with:
        //   - styleMask: [.titled, .fullSizeContentView, .nonactivatingPanel]
        //   - isFloatingPanel = true, level = .floating
        //   - titlebarAppearsTransparent = true
        //   - isMovableByWindowBackground = true
        //   - Fixed width 380pt
        //   - Centred on the connected display
        //   - Host PromptView via NSHostingView
    }

    /// Dismiss the prompt panel.
    func dismiss() {
        panel?.close()
        panel = nil
    }
}
