
import SwiftUI

@main
struct appApp: App {

    // Jailbreak check (unchanged)
    let isJailbroken = SecurityManager.shared.isDeviceJailbroken()

    // ✅ Runs ONCE when the app launches
    init() {
        createDemoBackupFile()
    }

    var body: some Scene {
        WindowGroup {
            if isJailbroken {
                AccessDeniedView()
            } else {
                ContentView()
            }
        }
    }
}
