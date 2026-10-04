import SwiftUI

/// Picks an unlock length in minutes by scrolling a column of numbers.
struct MinutesWheel: View {
    @Binding var value: Int

    static let range = 1...30

    private typealias Wheel = Metrics.Wheel

    var body: some View {
        ZStack {
            band
            numbers
            Text("Min")
                .textStyle(.label)
                .foregroundStyle(Palette.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, Wheel.size.width / 2 + Wheel.unitOffsetX)
                .allowsHitTesting(false)
        }
        .frame(width: Wheel.size.width, height: Wheel.size.height)
    }

    /// A snapping scroll view of 1 to 30. The vertical content margins let the
    /// first and last rows reach the center, and view-aligned snapping means
    /// it always settles with one row centered in the band.
    private var numbers: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 0) {
                ForEach(Self.range, id: \.self) { minutes in
                    Text("\(minutes)")
                        .textStyle(.wheelNumber)
                        .foregroundStyle(Palette.ink)
                        .frame(maxWidth: .infinity)
                        .frame(height: Wheel.rowHeight)
                }
            }
            .scrollTargetLayout()
        }
        .contentMargins(.vertical, (Wheel.size.height - Wheel.rowHeight) / 2, for: .scrollContent)
        .scrollTargetBehavior(.viewAligned)
        .scrollPosition(id: selection)
    }

    /// Bridges the non-optional `value` to the optional ID `scrollPosition` uses.
    private var selection: Binding<Int?> {
        Binding(get: { value }, set: { if let new = $0 { value = new } })
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
