import SwiftUI

/// The app's only main screen.
struct HomeView: View {
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading, spacing: 0) {
                header
                timeLeft
                Spacer(minLength: 0)
            }
            .padding(.horizontal, Metrics.screenPadding)
            // Face ID phones' status bar area already exceeds the minimum, so
            // this only adds room on home-button phones.
            .padding(.top, max(0, Metrics.minimumTopInset - geo.safeAreaInsets.top))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Background())
    }

    private var header: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: Metrics.headerLineGap) {
                Text(Self.dateFormatter.string(from: .now))
                    .textStyle(.date)
                    .foregroundStyle(Palette.ink)
                HStack(spacing: Metrics.statusDotGap) {
                    Circle()
                        .fill(Palette.idleDot)
                        .overlay(Circle().strokeBorder(.black.opacity(0.15), lineWidth: 0.8))
                        .frame(width: Metrics.statusDotSize, height: Metrics.statusDotSize)
                    Text("6 apps locked") // Static until apps can be picked.
                        .textStyle(.status)
                        .foregroundStyle(Palette.secondary)
                }
            }
            Spacer()
            SettingsButton()
        }
        .frame(height: Metrics.roundButton)
    }

    private var timeLeft: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Left today")
                .textStyle(.label)
                .foregroundStyle(Palette.secondary)
                .padding(.top, Metrics.labelTopSpacing)
            Text("1:12") // Static until time left is tracked.
                .textStyle(.heroTime)
                .lineHeight(Metrics.heroLineHeight, fontSize: TextStyle.heroTime.size)
                .foregroundStyle(Palette.ink)
                .padding(.top, Metrics.heroTopSpacing)
                .accessibilityLabel("1 hour 12 minutes left today")
        }
    }

    /// "Sat 26 Sep", matching the design's order in every locale.
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE d MMM"
        return formatter
    }()
}

/// The round, raised plastic button with the sliders icon.
private struct SettingsButton: View {
    var body: some View {
        Button {
            // Opens Settings in a later issue.
        } label: {
            SlidersIcon()
                .stroke(Palette.ink, style: StrokeStyle(lineWidth: 1.5, lineCap: .round, lineJoin: .round))
                .frame(width: 20, height: 20)
                .frame(width: Metrics.roundButton, height: Metrics.roundButton)
                .background {
                    Circle().fill(RadialGradient(
                        stops: Gradients.plastic,
                        center: Gradients.plasticCenter,
                        startRadius: 0,
                        endRadius: Metrics.roundButton * 0.75
                    ))
                }
                // Solid lip below, then a soft shadow.
                .background {
                    Circle()
                        .fill(Metrics.roundButtonLipColor)
                        .offset(y: Metrics.roundButtonLip)
                        .shadow(
                            color: Effects.roundButtonShadow.color,
                            radius: Effects.roundButtonShadow.radius,
                            y: Effects.roundButtonShadow.y - Metrics.roundButtonLip
                        )
                }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Settings")
    }
}

/// Two horizontal sliders, from the design's 24 pt icon.
private struct SlidersIcon: Shape {
    func path(in rect: CGRect) -> Path {
        let s = rect.width / 24
        func p(_ x: CGFloat, _ y: CGFloat) -> CGPoint { CGPoint(x: rect.minX + x * s, y: rect.minY + y * s) }
        var path = Path()
        path.move(to: p(4, 8)); path.addLine(to: p(13, 8))
        path.move(to: p(17, 8)); path.addLine(to: p(20, 8))
        path.addEllipse(in: CGRect(origin: p(13, 6), size: CGSize(width: 4 * s, height: 4 * s)))
        path.move(to: p(4, 16)); path.addLine(to: p(7, 16))
        path.move(to: p(11, 16)); path.addLine(to: p(20, 16))
        path.addEllipse(in: CGRect(origin: p(7, 14), size: CGSize(width: 4 * s, height: 4 * s)))
        return path
    }
}

/// The cream background: an elliptical gradient lit from the upper left.
private struct Background: View {
    var body: some View {
        GeometryReader { geo in
            let size = geo.size
            RadialGradient(
                stops: Gradients.background,
                center: Gradients.backgroundCenter,
                startRadius: 0,
                endRadius: size.width * Gradients.backgroundRadii.width
            )
            // Stretch the circle into the design's ellipse.
            .scaleEffect(
                x: 1,
                y: (size.height * Gradients.backgroundRadii.height) / (size.width * Gradients.backgroundRadii.width),
                anchor: Gradients.backgroundCenter
            )
        }
        .ignoresSafeArea()
    }
}

#Preview {
    HomeView()
}
