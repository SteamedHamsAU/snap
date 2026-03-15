import AppKit
import SwiftUI

/// Ephemeral toast notification for known-display auto-apply events.
///
/// Appears bottom-right of primary display, auto-dismisses after configurable duration.
/// See pane-spec Section 8.
@MainActor
final class ToastWindowController {

    private var panel: NSPanel?
    private var dismissTask: Task<Void, Never>?

    /// Show a toast notification.
    ///
    /// - Parameters:
    ///   - message: e.g. "LG UltraWide — extend left applied"
    ///   - duration: seconds before auto-dismiss (default 4)
    ///   - onChangeTapped: called when user taps the "change" link
    func show(
        message: String,
        duration: TimeInterval = 4,
        onChangeTapped: @escaping () -> Void
    ) {
        // TODO: Phase 3 — Create borderless NSPanel:
        //   - level = .floating
        //   - Position bottom-right, 20pt inset
        //   - Animate in: slide up 12pt + opacity 0→1 over 0.2s
        //   - Schedule dismissal after `duration`
        //   - Animate out: opacity 1→0 over 0.15s
    }

    /// Dismiss the toast immediately.
    func dismiss() {
        dismissTask?.cancel()
        panel?.close()
        panel = nil
    }
}
