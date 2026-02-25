
import SwiftUI

struct LoginView: View {

    @State private var username: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String = ""
    @State private var isLoading = false

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            VStack(spacing: 28) {

                Spacer()

                // MARK: - App Branding
                VStack(spacing: 8) {
                    Image(systemName: "lock.shield.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.blue)

                    Text("VaultPay")
                        .font(.largeTitle)
                        .bold()

                    Text("Secure Digital Payments")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                // MARK: - Login Card
                VStack(spacing: 18) {

                    VStack(alignment: .leading, spacing: 6) {
                        Text("Username")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        TextField("Enter username", text: $username)
                            .textFieldStyle(.plain)
                            .autocapitalization(.none)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(12)
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        Text("Password")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        SecureField("Enter password", text: $password)
                            .textFieldStyle(.plain)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(12)
                    }

                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    Button {
                        login()
                    } label: {
                        if isLoading {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Sign In")
                                .bold()
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(14)
                    .padding(.top, 8)
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(20)

                Spacer()

                // MARK: - Passive Hint (Lab)
                Text("⚠️ Authentication handled entirely on client-side")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
    }

    // ❌ Fake authentication logic (INTENTIONALLY INSECURE)
    private func login() {

        guard !username.isEmpty, !password.isEmpty else {
            errorMessage = "Username and password required"
            return
        }

        isLoading = true

        // Simulate network delay (UI realism only)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {

            let fakeToken = "token_\(UUID().uuidString)"

            let defaults = UserDefaults.standard
            defaults.set(true, forKey: "isLoggedIn")
            defaults.set(fakeToken, forKey: "authToken")
            defaults.set("user", forKey: "role")

            // 🔴 FORCE FLUSH TO DISK (for lab visibility)
            defaults.synchronize()

            errorMessage = ""
            isLoading = false
        }
    }
}
