import SwiftUI

/// Mirror mode tab: two option cards for mirror target selection.
///
/// See pane-spec Section 7 (MirrorView).
struct MirrorView: View {

    @Binding var selectedMirrorTarget: DisplayConfiguration.MirrorTarget

    var body: some View {
        // TODO: Phase 2 — HStack of two option cards:
        //   - "Optimise for MacBook" / "Optimise for external"
        //   - Diagram showing active/dimmed display
        //   - Subtitle with resolution implication
        HStack(spacing: 12) {
            ForEach(DisplayConfiguration.MirrorTarget.allCases, id: \.self) { target in
                Button {
                    selectedMirrorTarget = target
                } label: {
                    VStack(spacing: 8) {
                        // TODO: Phase 2 — Mirror diagram
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.secondary.opacity(0.2))
                            .frame(width: 64, height: 34)
                        Text(target.displayName)
                            .font(.caption)
                    }
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(selectedMirrorTarget == target ? Color.accentColor.opacity(0.1) : Color.clear)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(
                                selectedMirrorTarget == target ? Color.accentColor : Color.clear,
                                lineWidth: 1.5
                            )
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }
}
