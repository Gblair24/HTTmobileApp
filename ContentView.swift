import SwiftUI
import Charts

struct DashboardView: View {
    @State private var isMenuVisible = false
    @StateObject private var alertViewModel = AlertViewModel() // Add AlertViewModel

    var body: some View {
        NavigationView {
            ZStack(alignment: .leading) {
                // Main Content
                VStack {
                    HStack {
                        Button(action: {
                            withAnimation {
                                isMenuVisible.toggle()
                            }
                        })
                        {
                            Image(systemName: "line.horizontal.3")
                                .imageScale(.large)
                                .foregroundColor(.white)
                                .padding()
                                .offset(y:-2)
                        }
                        Spacer()
                        Text("Dashboard")
                            .font(.custom("Gordita-Bold", size: 35))
                            .foregroundColor(Color("HWhite"))
                            .padding(.leading, -100)
                        Spacer()
                        Image("logo")
                            .resizable()
                            .position(x:35, y:38)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 75, height: 75)
                        // You can add more buttons or icons here if needed
                    }
                    .frame(width: 400 ,height: 60 )
                    .background(Color("HBlack"))
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            GraphCardViewEndpoints()
                            if !alertViewModel.alerts.isEmpty {
                                GraphCardViewAlerts(alerts: alertViewModel.alerts)
                            } else if let errorMessage = alertViewModel.errorMessage {
                                Text("Error: \(errorMessage)")
                                    .foregroundColor(.red)
                                    .padding()
                            } else {
                                Text("Loading alerts...")
                                    .foregroundColor(.white)
                                    .padding()
                            }
                        }
                        .padding()
                    }
                    .background(Color("Charcoal"))
                }
                .navigationBarHidden(true)
                
                // Side Menu
                if isMenuVisible {
                    SideMenuView(isShowing: $isMenuVisible)
                        .frame(width: 250)
                        .transition(.move(edge: .leading))
                        .zIndex(1)
                }
                
                // Overlay to detect taps outside the menu
                if isMenuVisible {
                    Color.black.opacity(0.5)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                isMenuVisible = false
                            }
                        }
                        .zIndex(0)
                }
            }
        }
        .onAppear {
            alertViewModel.fetchAlert(from: "https://api.dev.httech.io/api/HTT/alerts", bearerToken: "226d5597-6efc-46e6-9dc1-11304ce1a9d5") //Start of issue with api 
        }
        .accentColor(.white)
    }
}

struct GraphCardViewEndpoints: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Endpoints")
                .foregroundColor(.white)
                .font(.custom("Gordita-Regular", size: 18))
            Text("50.8K")
                .foregroundColor(.white)
                .font(.custom("Gordita-Medium", size: 28))
            Text("12 mo")
                .foregroundColor(.gray)
                .font(.custom("Gordita-Regular", size: 15))
            Spacer()
            // Placeholder for the graph
            EndpointsChartView(endpoints: Endpoints.examples)
            Spacer()
            HStack {
                Spacer()
                Text("View Endpoints report")
                    .foregroundColor(Color("HTeal"))
                    .font(.custom("Gordita-Regular", size: 15))
            }
        }
        .padding()
        .background(Color(.black))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color("HTeal"), lineWidth: 1)
        )
    }
}

struct GraphCardViewAlerts: View {
    let alerts: [Alert] // Accept alerts as a parameter
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Alerts")
                .foregroundColor(.white)
                .font(.custom("Gordita-Regular", size: 18))
            Text(String(alerts.count))
                .foregroundColor(.white)
                .font(.custom("Gordita-Medium", size: 28))
            Text("Current Week")
                .foregroundColor(.gray)
                .font(.custom("Gordita-Regular", size: 15))
            Spacer()
            // Placeholder for the graph
            AlertChartView(alerts: alerts) // Pass the alerts data to AlertChartView
            Spacer()
            HStack {
                Spacer()
                NavigationLink(destination: AlertTableView(urlString: "https://api.dev.httech.io/api/HTT/alerts")) {
                    Text("View Alerts Report")
                        .foregroundColor(Color("HTeal"))
                        .font(.custom("Gordita-Regular", size: 15))
                }
            }
        }
        .padding()
        .background(Color(.black))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color("HTeal"), lineWidth: 1)
        )
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
