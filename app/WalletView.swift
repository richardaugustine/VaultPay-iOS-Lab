
import SwiftUI
import Security

struct WalletView: View {

    @State private var secretInput: String = ""
    @State private var showSavedAlert = false

    var body: some View {
        VStack(spacing: 20) {

            Text("Wallet")
                .font(.largeTitle)
                .bold()

            TextField("Enter ATM PIN / Sensitive Data", text: $secretInput)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numberPad)
                .padding(.horizontal)

            Text("(Value entered here is stored in iOS Keychain)")
                .font(.footnote)
                .foregroundColor(.gray)

            Button("Save to Wallet") {
                saveToKeychain(secretInput)
                secretInput = ""
                showSavedAlert = true
            }
            .buttonStyle(.borderedProminent)
            .disabled(secretInput.isEmpty)

            Spacer()
        }
        .padding()
        .alert("Saved", isPresented: $showSavedAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Sensitive data stored securely.")
        }
    }

    // 🔐 KEYCHAIN WRITE (INTENTIONALLY NORMAL)
    private func saveToKeychain(_ value: String) {

        guard let data = value.data(using: .utf8) else { return }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "wallet_service",
            kSecAttrAccount as String: "admin_wallet_secret",
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]

        // Overwrite if exists
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }
}
