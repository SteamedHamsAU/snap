import SwiftUI

/// Canvas-rendered diagram showing a display arrangement preset.
///
/// See pane-spec Section 11. Uses SwiftUI Canvas to avoid asset maintenance
/// as selection state changes colours dynamically.
struct ExtendPresetDiagram: View {

    let preset: DisplayConfiguration.ExtendPreset
    let isSelected: Bool

    var body: some View {
        Canvas { context, size in
            // TODO: Phase 2 — Draw MacBook rect (grey) + external rect
            //   - External: blue tint if selected, grey if not
            //   - Position based on preset (.externalRight, .externalLeft, .externalAbove)
            let macBookRect = CGRect(x: 0, y: 0, width: 30, height: 20)
            let externalColor: Color = isSelected ? .accentColor : .secondary

            switch preset {
            case .externalRight:
                context.fill(Path(macBookRect.offsetBy(dx: 0, dy: 7)), with: .color(.secondary))
                context.fill(
                    Path(CGRect(x: 32, y: 0, width: 30, height: 34)),
                    with: .color(externalColor.opacity(0.6))
                )
            case .externalLeft:
                context.fill(
                    Path(CGRect(x: 0, y: 0, width: 30, height: 34)),
                    with: .color(externalColor.opacity(0.6))
                )
                context.fill(Path(macBookRect.offsetBy(dx: 32, dy: 7)), with: .color(.secondary))
            case .externalAbove:
                context.fill(
                    Path(CGRect(x: 0, y: 0, width: 30, height: 14)),
                    with: .color(externalColor.opacity(0.6))
                )
                context.fill(Path(macBookRect.offsetBy(dx: 0, dy: 16)), with: .color(.secondary))
            }
        }
        .frame(width: 64, height: 34)
    }
}
