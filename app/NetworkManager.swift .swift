
import Foundation
import Security

class NetworkManager: NSObject {

    static let shared = NetworkManager()
    private override init() {}

    func fetchUsers(completion: @escaping ([DummyUser]) -> Void) {

        guard let url = URL(string: "https://example.com/api/admin/users") else {
            completion([])
            return
        }

        let session = URLSession(
            configuration: .default,
            delegate: self,
            delegateQueue: nil
        )

        let task = session.dataTask(with: url) { data, _, _ in

            guard let data = data else {
                DispatchQueue.main.async { completion([]) }
                return
            }

            do {
                let decoded = try JSONDecoder().decode(UserResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(decoded.users)
                }
            } catch {
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }

        task.resume()
    }
}

// MARK: - SSL PINNING (TARGET OF BYPASS)
extension NetworkManager: URLSessionDelegate {

    func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) {

        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }

        // ⚠️ Legacy trust evaluation (INTENTIONAL)
        var result = SecTrustResultType.invalid
        let status = SecTrustEvaluate(serverTrust, &result)

        if status == errSecSuccess &&
           (result == .unspecified || result == .proceed) {

            // ❌ No certificate / public key comparison
            completionHandler(.useCredential, URLCredential(trust: serverTrust))
        } else {
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }
}
