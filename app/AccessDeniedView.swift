
import SwiftUI

struct AccessDeniedView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "lock.shield")
                .font(.system(size: 48))
                .foregroundColor(.red)

            Text("Security Alert")
                .font(.title)
                .fontWeight(.bold)

            Text("This device does not meet security requirements.\nAccess has been blocked.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}
