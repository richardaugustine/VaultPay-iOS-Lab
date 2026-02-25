
import Foundation
import UIKit

class SecurityManager {

    static let shared = SecurityManager()
    private init() {}

    // ❌ Intentionally weak jailbreak detection (educational)
    func isDeviceJailbroken() -> Bool {

        print("[DEBUG] Jailbreak detection started")

        if isRunningOnSimulator() {
            print("[DEBUG] Simulator detected — skipping jailbreak checks")
            return false
        }

        // Legacy jailbreak indicators (will fail on rootless)
        let legacyPaths = [
            "/Applications/Cydia.app",
            "/Library/MobileSubstrate/MobileSubstrate.dylib",
            "/bin/bash",
            "/usr/sbin/sshd"
        ]

        for path in legacyPaths {
            if FileManager.default.fileExists(atPath: path) {
                print("[DEBUG] Legacy jailbreak indicator found:", path)
                return true
            }
        }

        // Rootless / palera1n-style indicators (best-effort)
        let rootlessPaths = [
            "/var/jb",
            "/var/jb/usr/bin",
            "/private/preboot"
        ]

        for path in rootlessPaths {
            if FileManager.default.fileExists(atPath: path) {
                print("[DEBUG] Rootless jailbreak indicator found:", path)
                return true
            }
        }

        // URL scheme check (often bypassed)
        if canOpenCydia() {
            print("[DEBUG] Jailbreak indicator via cydia:// scheme")
            return true
        }

        print("[DEBUG] Jailbreak check result: device not jailbroken")
        return false
    }

    // 🔴 Vulnerable logging (intentional)
    func logAuthState(isLoggedIn: Bool, role: String) {
        print("[DEBUG] Auth state — loggedIn:", isLoggedIn, "role:", role)
    }

    // MARK: - Helpers

    private func isRunningOnSimulator() -> Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }

    private func canOpenCydia() -> Bool {
        guard let url = URL(string: "cydia://package/com.example.package") else {
            return false
        }
        return UIApplication.shared.canOpenURL(url)
    }
}
