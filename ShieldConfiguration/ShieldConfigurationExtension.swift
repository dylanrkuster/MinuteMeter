import ManagedSettings
import ManagedSettingsUI
import UIKit

/// Draws the shield shown over a locked app.
class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    override func configuration(shielding application: Application) -> ShieldConfiguration {
        ShieldConfiguration()
    }
}
