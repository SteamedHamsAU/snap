import SwiftUI

/// Settings UI with General, Remembered Displays, and About sections.
///
/// See pane-spec Section 10.
struct SettingsView: View {

    var body: some View {
        // TODO: Phase 4 — Three sections:
        //
        // General:
        //   - Launch at login toggle (SMAppService)
        //   - Show toast on known display toggle
        //   - Toast duration stepper (2–8s, default 4)
        //
        // Remembered Displays:
        //   - Table: name, mode, preset
        //   - Per-row Forget button
        //   - Forget All button
        //
        // About:
        //   - Version number
        //   - Sparkle update check button
        //   - Link to website

        VStack {
            Text("Pane Settings")
                .font(.title2)
            Text("TODO: Settings UI")
                .foregroundStyle(.secondary)
        }
        .frame(width: 450, height: 400)
        .padding()
    }
}
