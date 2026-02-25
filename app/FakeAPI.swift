import Foundation

struct FakeAPI {

    // Post–SSL-pinning-bypass simulation
    static func fetchAdminUsers(role: String) -> [DummyUser] {

        guard role == "admin" else {
            return []
        }

        return [
            DummyUser(id: 1, name: "Amit", balance: 9_999_999),
            DummyUser(id: 2, name: "Sara", balance: 1),
            DummyUser(id: 3, name: "John", balance: 0)
        ]
    }
}
