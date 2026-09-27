import ActivityKit
import SwiftUI
import WidgetKit

/// Minutes and seconds left on an unlock, on the Lock Screen and in the Dynamic Island.
struct UnlockLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: UnlockActivityAttributes.self) { context in
            countdown(context.attributes)
                .padding()
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.center) {
                    countdown(context.attributes)
                }
            } compactLeading: {
                EmptyView()
            } compactTrailing: {
                countdown(context.attributes)
            } minimal: {
                EmptyView()
            }
        }
    }

    private func countdown(_ attributes: UnlockActivityAttributes) -> some View {
        Text(timerInterval: attributes.start...attributes.end, countsDown: true)
            .monospacedDigit()
    }
}
