import SwiftUI

struct ContentView: View {

    // ❌ Insecure authentication state (INTENTIONAL for lab)
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @AppStorage("role") private var role: String = "user"

    @State private var showAdminDashboard = false

    var body: some View {
        NavigationView {
            if isLoggedIn {
                loggedInView
            } else {
                LoginView()
            }
        }
        // Important for iPad / consistent behavior
        .navigationViewStyle(StackNavigationViewStyle())
    }

    // MARK: - Logged In UI (Modern Home)
    private var loggedInView: some View {
        ScrollView {
            VStack(spacing: 24) {

                // MARK: - Header
                VStack(alignment: .leading, spacing: 6) {
                    Text("VaultPay")
                        .font(.largeTitle)
                        .bold()

                    Text("Digital Payments & Wallet")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                // MARK: - Account Status Card
                VStack(spacing: 12) {
                    HStack {
                        Image(systemName: "person.crop.circle.fill")
                            .foregroundColor(.blue)
                        Text("Account Status")
                            .font(.headline)
                        Spacer()
                    }

                    HStack {
                        Text("Session")
                        Spacer()
                        Text("Active")
                            .foregroundColor(.green)
                            .bold()
                    }

                    HStack {
                        Text("Role")
                        Spacer()
                        Text(role.capitalized)
                            .foregroundColor(role == "admin" ? .red : .blue)
                            .bold()
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(16)

                // MARK: - Admin Entry Point (CLIENT-SIDE TRUST ❌)
                if role == "admin" {
                    Button {
                        showAdminDashboard = true
                    } label: {
                        HStack {
                            Image(systemName: "crown.fill")
                                .foregroundColor(.orange)

                            VStack(alignment: .leading) {
                                Text("Admin Dashboard")
                                    .font(.headline)
                                Text("Manage users, transactions & wallet")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }

                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                        .padding()
                    }
                    .background(Color.orange.opacity(0.12))
                    .cornerRadius(16)
                }

                // MARK: - Logout
                Button {
                    logout()
                } label: {
                    HStack {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                        Text("Logout")
                            .bold()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                }
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(14)

                // MARK: - Passive Hint
                Text("⚠️ Authentication & authorization handled client-side")
                    .font(.caption2)
                    .foregroundColor(.secondary)

                // 🔐 Hidden NavigationLink (iOS 15 replacement)
                NavigationLink(
                    destination: AdminDashboardView()
                        .onDisappear {
                            showAdminDashboard = false
                        },
                    isActive: $showAdminDashboard
                ) {
                    EmptyView()
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))

        // 🔴 Excessive Logging Vulnerability (INTENTIONAL)
        .onAppear {
            SecurityManager.shared.logAuthState(
                isLoggedIn: isLoggedIn,
                role: role
            )
        }
    }

    // MARK: - Logout Logic (INTENTIONALLY WEAK)
    private func logout() {
        isLoggedIn = false
        role = "user"
        UserDefaults.standard.removeObject(forKey: "authToken")
    }
}
