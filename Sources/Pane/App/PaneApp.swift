import AppKit

/// App entry point. Pane is a menu-bar-only app (LSUIElement = true).
@main
struct PaneApp {
    static func main() {
        let app = NSApplication.shared
        let delegate = AppDelegate()
        app.delegate = delegate
        app.run()
    }
}
