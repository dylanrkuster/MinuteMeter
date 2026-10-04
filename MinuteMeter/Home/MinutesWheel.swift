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
        .coordinateSpace(name: Self.space)
    }

    /// The wheel's own coordinate space, so each row can measure its distance
    /// from the wheel's center.
    nonisolated private static let space = "MinutesWheel"

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
                        .visualEffect { content, proxy in
                            // Signed distance from the wheel's center, in rows.
                            let rows = (proxy.frame(in: .named(Self.space)).midY - Wheel.size.height / 2) / Wheel.rowHeight
                            let distance = abs(rows)
                            return content
                                .scaleEffect(x: 1, y: Self.interpolate(Wheel.rowScales, at: distance))
                                .opacity(Self.interpolate(Wheel.rowOpacities.map { CGFloat($0) }, at: distance))
                                .offset(y: rows > 0 ? -Self.interpolate(Wheel.rowPulls, at: distance)
                                                    : Self.interpolate(Wheel.rowPulls, at: distance))
                        }
                }
            }
            .scrollTargetLayout()
        }
        .mask(
            LinearGradient(stops: [
                .init(color: .clear, location: 0),
                .init(color: .black, location: Wheel.edgeFade),
                .init(color: .black, location: 1 - Wheel.edgeFade),
                .init(color: .clear, location: 1),
            ], startPoint: .top, endPoint: .bottom)
        )
        .contentMargins(.vertical, (Wheel.size.height - Wheel.rowHeight) / 2, for: .scrollContent)
        .scrollTargetBehavior(.viewAligned)
        .scrollPosition(id: selection)
    }

    /// Reads `values` at a fractional index, blending linearly between neighbors.
    /// Past the last entry it holds the last value.
    nonisolated private static func interpolate(_ values: [CGFloat], at index: CGFloat) -> CGFloat {
        let lower = min(Int(index), values.count - 1)
        let upper = min(lower + 1, values.count - 1)
        let t = index - CGFloat(lower)
        return values[lower] + (values[upper] - values[lower]) * min(t, 1)
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
