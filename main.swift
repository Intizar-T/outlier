var body: some View {
    ZStack {
        Rectangle()
            .foregroundColor(.black)
            .edgesIgnoringSafeArea(.all)
        ScrollView {
            VStack {
                // Top section content
                VStack {
                    HStack {
                        // Add a temporary icon on the left
                        Image(systemName: "person")
                            .font(.system(size: 20))
                            .foregroundColor(.gray)
                            .padding(.leading, 10)
                        
                        Spacer()
                        Text("Hello, \(userData.name.components(separatedBy: " ").first ?? "")")
                            .font(.title)
                            .foregroundStyle(Color.white)
                        Spacer()
                        AsyncImage(url: URL(string: userData.photoURLString)) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40) // Adjust as needed
                                .clipShape(Circle()) // Make it circular
                        } placeholder: {
                            ProgressView()
                        }
                        .onTapGesture {
                            isUserDataViewActive = true
                        }
                    }
                    .sheet(isPresented: $isUserDataViewActive) {
                        SettingsView()
                    }
                    .padding()
                    
                    HStack {
                        // MARK: P/L Day rectangle
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 1)
                                .frame(width: 135, height: 100)
                            VStack {
                                profitLossDay()
                                    .padding([.bottom], 5)
                                Text("P/L Day")
                                    .foregroundStyle(Color.white)
                            }
                        }
                        .padding()
                        // MARK: # of trades
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 1)
                                .frame(width: 135, height: 100)
                            VStack {
                                numOfTrades()
                                    .padding([.bottom], 5)
                                Text("# of Trades")
                                    .foregroundStyle(Color.white)
                            }
                        }
                        .padding()
                    }
                    
                    HStack {
                        // MARK: Avg Percent
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 1)
                                .frame(width: 135, height: 100)
                            VStack {
                                avgPercent()
                                    .padding([.bottom], 5)
                                Text("Avg Percent")
                                    .foregroundStyle(Color.white)
                            }
                        }
                        .padding()
                        // MARK: WeeklyPT
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 1)
                                .frame(width: 135, height: 100)
                            VStack {
                                calcWeeklyPT()
                                    .padding([.bottom], 5)
                                Text("Weekly PT")
                                    .foregroundStyle(Color.white)
                            }
                        }
                        .padding()
                    }
                    .padding()
                }
                .padding()

                // Trade results section
                VStack {
                    var sortedWeeksTradesByProfit: [OptionTrade] {
                        weeksTrades.sorted { $0.calcProfit() > $1.calcProfit() }
                    }
                    Text("Top Performers")
                        .font(.title)
                        .foregroundStyle(Color.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                    VStack {
                        ForEach(sortedWeeksTradesByProfit.prefix(3)) { trade in
                            if trade.calcProfit() > 0 {
                                TopPerformer(trade: trade)
                            }
                        }
                    }
                }
                .padding()

                // Spacer to push the "Disclosures" down
                Spacer(minLength: 50)

                // Disclosures HStack
                HStack (spacing: 5) {
                    Text("View our full disclosures ")
                        .foregroundStyle(Color.white)
                    Button("here") {
                        print("hello")
                    }
                    .foregroundStyle(Color.white)
                    .padding(.leading, -5)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxHeight: .infinity)
        }
    }
}