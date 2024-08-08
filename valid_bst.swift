import CoreData
import SwiftUI

struct ErrorAlert: View {
    @State private var isShowingAlert = false
    let errorMessage: String

    var body: some View {
        Button("Trigger Alert", action: {
            isShowingAlert = true
        })
        .alert(isPresented: $isShowingAlert) {
            Alert(title: Text("Error Occurred!"), message: Text(self.errorMessage), dismissButton: .default(Text("OK")))
        }
    }
}

struct AddTrade: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView {
            AddOptionTrade(viewModel: OptionTradeViewModel())
                .tabItem {
                    Image(systemName: "triangleshape")
                        .foregroundStyle(.secondary)
                    Text("Option Trade")
                }
            AddFutureTrade()
                .tabItem {
                    Image(systemName: "calendar.badge.clock")
                    Text("Future Trade")
                }
            AddStockTrade(viewModel: StockTradeViewModel())
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Stock Trade")
                }
        }
    }
}

struct AddOptionTrade: View {
    @ObservedObject var viewModel: OptionTradeViewModel
    @Environment(\.dismiss) var dismiss
    @State private var errorMessage: String = ""
    @State private var showErrorAlert: Bool = false

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
                if viewModel.saveTrade() {
                    dismiss() // Dismiss the view after saving
                } else {
                    errorMessage = "Failed to save trade. Please check your inputs."
                    showErrorAlert = true
                }
            }
            .disabled(viewModel.ticker.isEmpty || viewModel.strikePrice.isEmpty || viewModel.buyPrice.isEmpty)
        }
        .navigationTitle("Add Option Trade")
        .alert(isPresented: $showErrorAlert) {
            Alert(title: Text("Error Occurred!"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
    }
}

struct AddFutureTrade: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: FutureTradeViewModel = FutureTradeViewModel()
    @State private var errorMessage: String = ""
    @State private var showErrorAlert: Bool = false

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
                if viewModel.saveTrade() {
                    dismiss() // Dismiss the view after saving
                } else {
                    errorMessage = "Failed to save trade. Please check your inputs."
                    showErrorAlert = true
                }
            }
            .disabled(viewModel.ticker.isEmpty || viewModel.tickSize.isEmpty || viewModel.quantity.isEmpty || viewModel.buyPrice.isEmpty)
        }
        .navigationTitle("Add Future Trade")
        .alert(isPresented: $showErrorAlert) {
            Alert(title: Text("Error Occurred!"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
    }
}

struct AddStockTrade: View {
    @ObservedObject var viewModel: StockTradeViewModel
    @Environment(\.dismiss) var dismiss
    @State private var errorMessage: String = ""
    @State private var showErrorAlert: Bool = false

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
                if viewModel.saveTrade() {
                    dismiss() // Dismiss the view after saving
                } else {
                    errorMessage = "Failed to save trade. Please check your inputs."
                    showErrorAlert = true
                }
            }
            .disabled(viewModel.ticker.isEmpty || viewModel.quantity.isEmpty || viewModel.buyPrice.isEmpty)
        }
        .navigationTitle("Add Stock Trade")
        .alert(isPresented: $showErrorAlert) {
            Alert(title: Text("Error Occurred!"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
    }
}

struct AddTrade_Preview: PreviewProvider {
    static var previews: some View {
        AddTrade()
    }
}