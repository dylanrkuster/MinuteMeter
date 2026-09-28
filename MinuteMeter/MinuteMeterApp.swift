import SwiftUI

@main
struct MinuteMeterApp: App {
    @State private var today = TodayModel()

    var body: some Scene {
        WindowGroup {
            TodayView(model: today)
        }
    }
}
