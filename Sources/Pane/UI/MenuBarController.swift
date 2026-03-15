import AppKit

/// Manages the menu bar status item and its dynamic menu.
///
/// See pane-spec Section 9 for menu structure.
@MainActor
final class MenuBarController {

    private var statusItem: NSStatusItem?
    private let configStore: DisplayConfigStore

    init(configStore: DisplayConfigStore) {
        self.configStore = configStore
    }

    /// Set up the NSStatusItem in the system menu bar.
    func setup() {
        // TODO: Phase 3 — Create NSStatusItem:
        //   - Template image (display icon, 18×18pt)
        //   - Build menu dynamically on each open
        //   - Menu structure per spec Section 9
    }

    /// Rebuild the menu contents (call when state changes).
    func updateMenu() {
        // TODO: Phase 3 — Dynamic menu:
        //   - Current display status (name, mode, preset)
        //   - Re-trigger prompt (disabled if no external connected)
        //   - Open settings...
        //   - Remembered displays submenu with Forget actions
        //   - Quit Pane
    }
}
