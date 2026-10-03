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

    /// The recessed band behind the selected row, drawn as layers: a faint fill,
    /// a soft shadow just inside the top edge, and a thin white highlight just
    /// inside the bottom edge.
    private var band: some View {
        let shape = RoundedRectangle(cornerRadius: Wheel.bandRadius)
        return shape
            .fill(Effects.wheelBandFill)
            // Inner shadow: a blurred stroke on the edge, shifted down, clipped inside.
            .overlay {
                shape
                    .stroke(Effects.wheelBandShadow.color, lineWidth: Effects.wheelBandShadow.radius * 2)
                    .blur(radius: Effects.wheelBandShadow.radius)
                    .offset(y: Effects.wheelBandShadow.y)
                    .clipShape(shape)
            }
            // Bottom highlight: the band minus a copy shifted up 1 pt leaves a
            // 1 pt sliver along the bottom edge.
            .overlay {
                ZStack {
                    shape.fill(Effects.wheelBandHighlight)
                    shape.offset(y: -1).blendMode(.destinationOut)
                }
                .compositingGroup()
                .clipShape(shape)
            }
            .frame(height: Wheel.bandHeight)
    }
}
