import SwiftUI

@main
struct MinuteMeterApp: App {
    var body: some Scene {
        WindowGroup {
            ZStack {
                Palette.background.ignoresSafeArea()
                Text("Minute Meter")
                    .textStyle(.title)
                    .foregroundStyle(Palette.textPrimary)
            }
        }
    }
}
