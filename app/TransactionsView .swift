import SwiftUI

struct TransactionsView: View {

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            Text("Recent Transactions")
                .font(.title)
                .bold()

            Divider()

            Text("₹12,000  - Amazon")
            Text("₹5,500   - Flipkart")
            Text("₹1,200   - Swiggy")
            Text("₹30,000  - Rent")

            Spacer()
        }
        .padding()
        .navigationTitle("Transactions")
    }
}
