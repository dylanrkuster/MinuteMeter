import SwiftUI

/// Picks an unlock length in minutes. Static for now: shows the selected value
/// in its band with the "MIN" label.
struct MinutesWheel: View {
    let value: Int

    private typealias Wheel = Metrics.Wheel

    var body: some View {
        ZStack {
            band
            Text("\(value)")
                .textStyle(.wheelNumber)
                .foregroundStyle(Palette.ink)
                .frame(height: Wheel.rowHeight)
            Text("Min")
                .textStyle(.label)
                .foregroundStyle(Palette.secondary)
                .fixedSize()
                .frame(width: Wheel.size.width, alignment: .leading)
                .padding(.leading, Wheel.size.width + 2 * Wheel.unitOffsetX)
                .frame(width: Wheel.size.width)
        }
        .frame(width: Wheel.size.width, height: Wheel.size.height)
    }

    /// The recessed band behind the selected row.
    private var band: some View {
        RoundedRectangle(cornerRadius: Wheel.bandRadius)
            .fill(
                Effects.wheelBandFill
                    .shadow(.inner(color: Effects.wheelBandShadow.color,
                                   radius: Effects.wheelBandShadow.radius,
                                   y: Effects.wheelBandShadow.y))
                    .shadow(.inner(color: Effects.wheelBandHighlight, radius: 0, y: -1))
            )
            .frame(height: Wheel.bandHeight)
    }
}
