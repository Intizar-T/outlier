import CoreData
import SwiftUI

struct AddTrade: View {
    @State private var selectedTab = 0
    @State private var errorMessage: String = ""
    @State private var isShowingAlert = false

    var body: some View {
        TabView {
            AddOptionTrade(viewModel: OptionTradeViewModel(), errorMessage: $errorMessage, isShowingAlert: $isShowingAlert)
                .tabItem {
                    Image(systemName: "triangleshape")
                        .foregroundStyle(.secondary)
                    Text("Option Trade")
                }
            AddFutureTrade(errorMessage: $errorMessage, isShowingAlert: $isShowingAlert)
                .tabItem {
                    Image(systemName: "calendar.badge.clock")
                    Text("Future Trade")
                }
            AddStockTrade(viewModel: StockTradeViewModel(), errorMessage: $errorMessage, isShowingAlert: $isShowingAlert)
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Stock Trade")
                }
        }
        .alert(isPresented: $isShowingAlert) {
            Alert(title: Text("Error Occurred!"), message: Text(self.errorMessage), dismissButton: .default(Text("OK")))
        }
    }
}

struct AddOptionTrade: View {
    @ObservedObject var viewModel: OptionTradeViewModel
    @Environment(\.dismiss) var dismiss
    @Binding var errorMessage: String
    @Binding var isShowingAlert: Bool

    var body: some View {
        Form {
            Section(header: Text("Trade Details")) {
                TextField("Ticker", text: $viewModel.ticker)
                TextField("Strike Price", text: $viewModel.strikePrice)
                    .keyboardType(.decimalPad)
                TextField("Quantity", text: $viewModel.quantity)
                    .keyboardType(.numberPad)
                TextField("Buy Price", text: $viewModel.buyPrice)
                    .keyboardType(.decimalPad)
                TextField("Sell Price (Optional)", text: $viewModel.sellPrice)
                    .keyboardType(.decimalPad)
                DatePicker("Expiration Date", selection: $viewModel.expDate, displayedComponents: .date)
                HStack {
                    Text("Side")
                    Spacer()
                    Image(systemName: "arrow.up")
                        .foregroundStyle(viewModel.callPut ? Color.green : Color.black)
                        .onTapGesture {
                            self.viewModel.callPut = true
                        }

                    Image(systemName: "arrow.down")
                        .foregroundStyle(viewModel.callPut ? Color.black : Color.red)
                        .onTapGesture {
                            self.viewModel.callPut = false // Set to "Put" when down arrow is tapped
                        }
                }
                TextField("Note (Optional)", text: $viewModel.note)
            }

            Button("Save Trade") {
                if viewModel.ticker.isEmpty || viewModel.strikePrice.isEmpty || viewModel.buyPrice.isEmpty {
                    errorMessage = "Please fill in all required fields."
                    isShowingAlert = true
                } else {
                    viewModel.saveTrade()
                    dismiss() // Dismiss the view after saving
                }
            }
            .disabled(viewModel.ticker.isEmpty || viewModel.strikePrice.isEmpty || viewModel.buyPrice.isEmpty)
        }
        .navigationTitle("Add Option Trade")
    }
}

struct AddFutureTrade: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: FutureTradeViewModel = FutureTradeViewModel()
    @Binding var errorMessage: String
    @Binding var isShowingAlert: Bool

    var body: some View {
        Form {
            Section(header: Text("Trade Details")) {
                TextField("Ticker", text: $viewModel.ticker)
                TextField("Tick Size", text: $viewModel.tickSize)
                    .keyboardType(.decimalPad)
                TextField("Quantity", text: $viewModel.quantity)
                    .keyboardType(.numberPad)
                TextField("Buy Price", text: $viewModel.buyPrice)
                    .keyboardType(.decimalPad)
                TextField("Sell Price (Optional)", text: $viewModel.sellPrice)
                    .keyboardType(.decimalPad)
                Toggle("Is Long", isOn: $viewModel.isLong) // New field for isLong
                TextField("Note (Optional)", text: $viewModel.note)
            }

            Button("Save Trade") {
                if viewModel.ticker.isEmpty || viewModel.tickSize.isEmpty || viewModel.quantity.isEmpty || viewModel.buyPrice.isEmpty {
                    errorMessage = "Please fill in all required fields."
                    isShowingAlert = true
                } else {
                    viewModel.saveTrade()
                    dismiss() // Dismiss the view after saving
                }
            }
            .disabled(viewModel.ticker.isEmpty || viewModel.tickSize.isEmpty || viewModel.quantity.isEmpty || viewModel.buyPrice.isEmpty)
        }
        .navigationTitle("Add Future Trade")
    }
}

struct AddStockTrade: View {
    @ObservedObject var viewModel: StockTradeViewModel
    @Environment(\.dismiss) var dismiss
    @Binding var errorMessage: String
    @Binding var isShowingAlert: Bool

    var body: some View {
        Form {
            Section(header: Text("Trade Details")) {
                TextField("Ticker", text: $viewModel.ticker)
                TextField("Quantity", text: $viewModel.quantity)
                    .keyboardType(.numberPad)
                TextField("Buy Price", text: $viewModel.buyPrice)
                    .keyboardType(.decimalPad)
                TextField("Sell Price (Optional)", text: $viewModel.sellPrice)
                    .keyboardType(.decimalPad)
                Toggle("Is Long", isOn: $viewModel.isLong) // New field for isLong
                TextField("Note (Optional)", text: $viewModel.note)
            }

            Button("Save Trade") {
                if viewModel.ticker.isEmpty || viewModel.quantity.isEmpty || viewModel.buyPrice.isEmpty {
                    errorMessage = "Please fill in all required fields."
                    isShowingAlert = true
                } else {
                    viewModel.saveTrade()
                    dismiss() // Dismiss the view after saving
                }
            }
            .disabled(viewModel.ticker.isEmpty || viewModel.quantity.isEmpty || viewModel.buyPrice.isEmpty)
        }
        .navigationTitle("Add Stock Trade")
    }
}

struct AddTrade_Preview: PreviewProvider {
    static var previews: some View {
        AddTrade()
    }
}