import SwiftUI

/// A ruler that shows how much of a span of time is left: a Brass band for the
/// time left, a gray track for the time used, and a pointer where they meet.
///
/// Used for today's limit on Today and, later, for an unlock's length on the
/// Unlocked screen. Drawn in one `Canvas` because it's mostly many small ticks,
/// which a canvas draws cheaply. Measurements come from the mockups.
struct TimeTape: View {
    let totalMinutes: Int
    let remainingMinutes: Int
    /// Evenly spaced labels from start to end, for example "0", "0:30", … "2:00".
    /// A major tick is drawn above each one.
    let labels: [String]

    static let height = Metrics.tapeHeight

    var body: some View {
        Canvas { context, size in
            draw(in: &context, size: size)
        }
        .frame(height: Self.height)
        .accessibilityElement()
        .accessibilityLabel("Time left")
        .accessibilityValue("\(remainingMinutes) of \(totalMinutes) minutes")
    }

    private var fractionLeft: CGFloat {
        guard totalMinutes > 0 else { return 0 }
        return min(1, max(0, CGFloat(remainingMinutes) / CGFloat(totalMinutes)))
    }

    private func draw(in context: inout GraphicsContext, size: CGSize) {
        let width = size.width
        let bandEnd = width * fractionLeft

        // Minor ticks: short marks every 2.85 pt.
        let minorPitch: CGFloat = 2.85
        var minor = Path()
        var x: CGFloat = 0
        while x <= width {
            minor.addRect(CGRect(x: x, y: 17, width: 0.9, height: 10))
            x += minorPitch
        }
        context.fill(minor, with: .color(Palette.tick))

        // Major ticks: one above each label. The end ticks are inset so they
        // aren't cut in half.
        var major = Path()
        for index in labels.indices {
            let x = labelX(index, width: width)
            let tickX = min(max(x, 0.8), width - 0.8)
            major.addRect(CGRect(x: tickX - 0.8, y: 13, width: 1.6, height: 15))
        }
        context.fill(major, with: .color(Palette.textPrimary))

        // Track for time used, then the Brass band for time left, with a glow.
        let bandY: CGFloat = 31
        let bandHeight = Metrics.tapeBandHeight
        let radius = Metrics.tapeBandRadius
        let trackStart = bandEnd > 0 ? bandEnd + 2 : 0
        if trackStart < width {
            let track = CGRect(x: trackStart, y: bandY, width: width - trackStart, height: bandHeight)
            context.fill(Path(roundedRect: track, cornerRadius: radius), with: .color(Palette.track))
        }
        if bandEnd > 0 {
            let band = CGRect(x: 0, y: bandY, width: bandEnd, height: bandHeight)
            context.drawLayer { layer in
                layer.addFilter(.shadow(color: Accent.glow, radius: Effects.accentGlowRadius))
                layer.fill(Path(roundedRect: band, cornerRadius: radius), with: .color(Accent.base))
            }
        }

        // Pointer above the end of the band, kept fully on screen.
        let pointerX = min(max(bandEnd, 6), width - 6)
        var pointer = Path()
        pointer.move(to: CGPoint(x: pointerX - 6, y: 1))
        pointer.addLine(to: CGPoint(x: pointerX + 6, y: 1))
        pointer.addLine(to: CGPoint(x: pointerX, y: 10))
        pointer.closeSubpath()
        context.fill(pointer, with: .color(Palette.textPrimary))

        // Labels: the first is left-aligned, the last right-aligned, the rest centered.
        for (index, label) in labels.enumerated() {
            let anchor: UnitPoint = index == 0 ? .bottomLeading
                : index == labels.count - 1 ? .bottomTrailing
                : .bottom
            let text = Text(label)
                .font(Typeface.condensed(11))
                .foregroundColor(Palette.textSecondary)
            context.draw(text, at: CGPoint(x: labelX(index, width: width), y: 61), anchor: anchor)
        }
    }

    private func labelX(_ index: Int, width: CGFloat) -> CGFloat {
        guard labels.count > 1 else { return 0 }
        return width * CGFloat(index) / CGFloat(labels.count - 1)
    }
}

#Preview {
    TimeTape(totalMinutes: 120, remainingMinutes: 72, labels: ["0", "0:30", "1:00", "1:30", "2:00"])
        .padding(24)
        .background(Palette.background)
}
