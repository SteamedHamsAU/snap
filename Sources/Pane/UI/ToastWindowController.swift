import AppKit
import SwiftUI

/// Shows a toast notification for known-display auto-apply events.
@MainActor
final class ToastWindowController: NSObject {

    private var panel: NSPanel?
    private var dismissTask: Task<Void, Never>?

    func show(
        message: String,
        duration: TimeInterval = 4,
        onChangeTapped: @escaping () -> Void
    ) {
        dismiss()

        let toastView = ToastView(message: message, onChangeTapped: { [weak self] in
            self?.dismiss()
            onChangeTapped()
        })

        let hostingView = NSHostingView(rootView: toastView)
        hostingView.setFrameSize(hostingView.fittingSize)

        let contentSize = hostingView.fittingSize
        let panel = NSPanel(
            contentRect: NSRect(origin: .zero, size: contentSize),
            styleMask: [.titled, .fullSizeContentView, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        panel.isFloatingPanel = true
        panel.level = .screenSaver
        panel.titlebarAppearsTransparent = true
        panel.titleVisibility = .hidden
        panel.isMovableByWindowBackground = true
        panel.contentView = hostingView
        panel.isReleasedWhenClosed = false
        panel.collectionBehavior = [.canJoinAllSpaces, .transient]

        // Position top-right of built-in screen
        let screen = builtInScreen() ?? NSScreen.main ?? NSScreen.screens.first
        if let screenFrame = screen?.visibleFrame {
            let x = screenFrame.maxX - contentSize.width - 16
            let y = screenFrame.maxY - contentSize.height - 8
            panel.setFrameOrigin(NSPoint(x: x, y: y))
        }

        panel.orderFrontRegardless()
        self.panel = panel

        // Schedule auto-dismiss
        dismissTask = Task {
            try? await Task.sleep(for: .seconds(duration))
            guard !Task.isCancelled else { return }
            dismiss()
        }
    }

    func dismiss() {
        dismissTask?.cancel()
        dismissTask = nil
        panel?.close()
        panel = nil
    }

    private func builtInScreen() -> NSScreen? {
        NSScreen.screens.first { screen in
            guard let screenNumber = screen.deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as? CGDirectDisplayID else {
                return false
            }
            return CGDisplayIsBuiltin(screenNumber) != 0
        }
    }
}

/// SwiftUI view for the toast content.
private struct ToastView: View {
    let message: String
    let onChangeTapped: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 24))
                .foregroundStyle(.green)

            VStack(alignment: .leading, spacing: 3) {
                Text(message)
                    .font(.system(size: 14, weight: .medium))

                Button("Change…") {
                    onChangeTapped()
                }
                .font(.system(size: 12))
                .buttonStyle(.link)
            }

            Spacer(minLength: 0)
        }
        .padding(16)
        .frame(width: 340)
    }
}
