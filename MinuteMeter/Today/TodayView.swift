import SwiftUI

/// Screen 07: time left today.
struct TodayView: View {
    let model: TodayModel

    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header
            timeLeft
            TimeTape(
                totalMinutes: model.limitMinutes,
                remainingMinutes: model.leftMinutes ?? 0,
                labels: Self.tapeLabels(limitMinutes: model.limitMinutes)
            )
            .padding(.top, 18)
            Spacer(minLength: 0)
        }
        .padding(.horizontal, Metrics.screenPadding)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Palette.background)
        .onChange(of: scenePhase) { _, phase in
            if phase == .active { model.refresh() }
        }
        // Fires at midnight and when the clock or time zone changes.
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.significantTimeChangeNotification)) { _ in
            model.refresh()
        }
    }

    private var header: some View {
        Text(model.dateText)
            .textStyle(.date)
            .foregroundStyle(Palette.textPrimary)
            .frame(height: Metrics.headerButton)
    }

    private var timeLeft: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Left today")
                .textStyle(.label)
                .foregroundStyle(Palette.textSecondary)
                .padding(.top, 22)

            HStack(alignment: .lastTextBaseline) {
                Text(Self.format(model.leftMinutes))
                    .textStyle(.heroTime)
                    .lineHeight(0.92, fontSize: 116)
                    .foregroundStyle(Palette.textPrimary)
                    .accessibilityLabel("Left today")
                    .accessibilityValue(model.leftMinutes.map(TimeMath.spoken) ?? "Unknown")
                    .accessibilityIdentifier("timeLeft")
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Of \(TimeMath.format(minutes: model.limitMinutes))")
                    Text("\(Self.format(model.usedMinutes)) used")
                }
                .textStyle(.label)
                .foregroundStyle(Palette.textSecondary)
                .accessibilityElement(children: .combine)
            }
        }
    }

    /// Five labels at quarters of the limit: "0", "0:30", "1:00", "1:30", "2:00".
    static func tapeLabels(limitMinutes: Int) -> [String] {
        (0...4).map { quarter in
            quarter == 0 ? "0" : TimeMath.format(minutes: limitMinutes * quarter / 4)
        }
    }

    /// `h:mm`, or a placeholder when history couldn't be read.
    private static func format(_ minutes: Int?) -> String {
        minutes.map { TimeMath.format(minutes: $0) } ?? "–:––"
    }
}

#Preview {
    TodayView(model: TodayModel())
}
