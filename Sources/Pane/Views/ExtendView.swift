import SwiftUI

/// Extend mode tab: three preset cards showing display arrangement options.
///
/// See pane-spec Section 7 (ExtendView).
struct ExtendView: View {

    @Binding var selectedPreset: DisplayConfiguration.ExtendPreset

    var body: some View {
        // TODO: Phase 2 — HStack of three preset cards:
        //   - Each card: ExtendPresetDiagram + label
        //   - Selected: 1.5pt blue border + light blue tint
        HStack(spacing: 12) {
            ForEach(DisplayConfiguration.ExtendPreset.allCases, id: \.self) { preset in
                Button {
                    selectedPreset = preset
                } label: {
                    VStack(spacing: 8) {
                        ExtendPresetDiagram(
                            preset: preset,
                            isSelected: selectedPreset == preset
                        )
                        Text(preset.displayName)
                            .font(.caption)
                    }
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(selectedPreset == preset ? Color.accentColor.opacity(0.1) : Color.clear)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(
                                selectedPreset == preset ? Color.accentColor : Color.clear,
                                lineWidth: 1.5
                            )
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }
}
