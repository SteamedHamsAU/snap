import SwiftUI

/// Root SwiftUI view for the display configuration prompt.
///
/// Structure per pane-spec Section 7:
/// - Header: icon, display name, resolution
/// - Segmented control: Extend | Mirror
/// - ExtendView or MirrorView
/// - Footer: remember checkbox, dismiss, apply
struct PromptView: View {

    let displayName: String
    let resolution: CGSize
    let onApply: (DisplayConfiguration) -> Void
    let onDismiss: () -> Void

    @State private var selectedMode: DisplayConfiguration.Mode = .extend
    @State private var selectedPreset: DisplayConfiguration.ExtendPreset = .externalRight
    @State private var selectedMirrorTarget: DisplayConfiguration.MirrorTarget = .macBook
    @State private var rememberDisplay: Bool = true

    var body: some View {
        // TODO: Phase 2 — Layout per spec Section 7:
        // VStack spacing=0 {
        //   Header row (icon, name, resolution)
        //   Divider
        //   Segmented picker (Extend | Mirror)
        //   ExtendView or MirrorView
        //   Divider
        //   Footer (remember checkbox, dismiss, apply)
        // }
        VStack {
            Text("Configure \(displayName)")
                .font(.headline)
            Text("TODO: Full prompt UI")
                .foregroundStyle(.secondary)
        }
        .frame(width: 360)
        .padding()
    }

    private func buildConfiguration() -> DisplayConfiguration {
        DisplayConfiguration(
            mode: selectedMode,
            extendPreset: selectedPreset,
            mirrorTarget: selectedMirrorTarget,
            rememberThisDisplay: rememberDisplay
        )
    }
}
