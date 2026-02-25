import SwiftUI
import LocalAuthentication

struct AdminDashboardView: View {

    // MARK: - State
    @State private var users: [DummyUser] = []
    @State private var isLoading = false
    @State private var networkAttempted = false

    // Phase 7
    @State private var biometricPassed = false
    @State private var showTransactions = false
    @State private var showAuthError = false

    // Phase 8
    @State private var showWallet = false

    // Lifecycle guard
    @State private var didLoadOnce = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {

                    // MARK: - Header
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Admin Dashboard")
                            .font(.largeTitle)
                            .bold()

                        Text("VaultPay Secure Console")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    // MARK: - Network Status Card (Phase 6)
                    VStack(spacing: 12) {
                        HStack {
                            Image(systemName: "network")
                                .foregroundColor(.blue)
                            Text("User Balances")
                                .font(.headline)
                            Spacer()
                        }

                        if isLoading {
                            ProgressView("Fetching user balances…")
                        }

                        if !isLoading && users.isEmpty && networkAttempted {
                            VStack(spacing: 6) {
                                Text("No data returned")
                                    .foregroundColor(.gray)

                                Text("Network request blocked")
                                    .font(.caption)
                                    .foregroundColor(.orange)

                                Text("Possible SSL pinning enforcement")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                        }

                        if !users.isEmpty {
                            VStack(spacing: 10) {
                                ForEach(users) { user in
                                    HStack {
                                        Text(user.name)
                                        Spacer()
                                        Text("₹\(user.balance)")
                                            .bold()
                                    }
                                    .padding(.vertical, 4)
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(16)

                    // MARK: - Actions
                    VStack(spacing: 16) {

                        // Transactions (Biometric)
                        Button {
                            authenticateBiometric()
                        } label: {
                            HStack {
                                Image(systemName: "lock.shield")
                                Text("Transactions")
                                    .bold()
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                            .padding()
                        }
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(14)

                        // Wallet (Keychain)
                        Button {
                            showWallet = true
                        } label: {
                            HStack {
                                Image(systemName: "wallet.pass")
                                Text("Wallet")
                                    .bold()
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                            .padding()
                        }
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(14)
                    }

                    // MARK: - Footer Hint
                    Text("🔐 Client-side security controls active")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .padding(.top, 8)

                    // 🔐 Hidden navigation links (iOS 15 compatible)

                    NavigationLink(
                        destination: TransactionsView(),
                        isActive: $showTransactions
                    ) {
                        EmptyView()
                    }

                    NavigationLink(
                        destination: WalletView(),
                        isActive: $showWallet
                    ) {
                        EmptyView()
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))

            // Lifecycle
            .onAppear {
                if !didLoadOnce {
                    didLoadOnce = true
                    loadUsers()
                }
            }

            // Alerts
            .alert("Access Denied",
                   isPresented: $showAuthError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Biometric verification required")
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    // MARK: - Biometric (Phase 7)
    private func authenticateBiometric() {

        #if targetEnvironment(simulator)
        showAuthError = true
        return
        #endif

        let context = LAContext()
        var error: NSError?

        let policy = LAPolicy.deviceOwnerAuthenticationWithBiometrics

        if context.canEvaluatePolicy(policy, error: &error) {
            context.evaluatePolicy(
                policy,
                localizedReason: "Authenticate to view transactions"
            ) { success, _ in
                DispatchQueue.main.async {
                    if success {
                        biometricPassed = true // intentional flaw
                        showTransactions = true
                    } else {
                        showAuthError = true
                    }
                }
            }
        } else {
            showAuthError = true
        }
    }

    // MARK: - Network Call (Phase 6)
    private func loadUsers() {

        print("[+] loadUsers called")

        networkAttempted = true
        isLoading = true

        NetworkManager.shared.fetchUsers { fetchedUsers in
            DispatchQueue.main.async {
                print("[+] fetchUsers callback hit")
                self.users = fetchedUsers
                self.isLoading = false
            }
        }
    }
}
