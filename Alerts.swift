
import SwiftUI
import Charts
import Foundation

// Define the Alert struct
struct Alert: Codable, Identifiable {
    let category: String
    let closureCode: String? // Make closureCode optional
    let createdAt: Date
    let createdBy: String // Change from Int to String
    let customer: String
    let date: String
    let description: String
    let id: Int
    let references: String
    let rule: String
    let severity: String
    let source: String
    let sourceRef: String
    let status: String
    let tags: String
    let title: String
    let updatedAt: Date
    let updatedBy: String // Change from Int to String

    enum CodingKeys: String, CodingKey {
        case category
        case closureCode = "closure_code"
        case createdAt = "created_at"
        case createdBy = "created_by"
        case customer
        case date
        case description
        case id
        case references
        case rule
        case severity
        case source
        case sourceRef = "source_ref"
        case status
        case tags
        case title
        case updatedAt = "updated_at"
        case updatedBy = "updated_by"
    }
}




class AlertViewModel: ObservableObject {
    @Published var alerts: [Alert] = []
    @Published var errorMessage: String?

    func fetchAlert(from urlString: String, bearerToken: String) {
        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
                print("Error fetching data: \(error)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    self.errorMessage = "Invalid response from server"
                }
                print("Invalid response from server")
                return
            }

            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let iso8601Formatter = ISO8601DateFormatter()
                    iso8601Formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                    
                    let alternateIso8601Formatter = ISO8601DateFormatter()
                    alternateIso8601Formatter.formatOptions = [.withInternetDateTime]

                    decoder.dateDecodingStrategy = .custom { decoder in
                        let container = try decoder.singleValueContainer()
                        let dateString = try container.decode(String.self)
                        
                        if let date = iso8601Formatter.date(from: dateString) {
                            return date
                        } else if let alternateDate = alternateIso8601Formatter.date(from: dateString) {
                            return alternateDate
                        } else {
                            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date string: \(dateString)")
                        }
                    }

                    let decodedAlerts = try decoder.decode([Alert].self, from: data)

                    DispatchQueue.main.async {
                        self.alerts = decodedAlerts
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.errorMessage = error.localizedDescription
                    }
                    print("Error decoding data: \(error)")
                }
            }
        }.resume()
    }
}

struct AlertTableView: View {
    @StateObject private var viewModel = AlertViewModel()
    let urlString: String

    @State private var createdAtFilter: CreatedAtFilter = .all
    @State private var filterSeverity: SeverityFilter = .all
    @State private var filterStatus: StatusFilter = .all

    enum CreatedAtFilter: String, CaseIterable {
        case all = "All"
        case last7Days = "Last 7 Days"
        case last24Hours = "Last 24 Hours"
    }

    enum SeverityFilter: String, CaseIterable {
        case all = "All"
        case low = "Low"
        case medium = "Medium"
        case high = "High"
    }

    enum StatusFilter: String, CaseIterable {
        case all = "All"
        case new = "Open"
        case closed = "Closed"
        case inReview = "In Review"
    }
        

    var body: some View {
        VStack {
            filterControls
            
            Group {
                if !viewModel.alerts.isEmpty {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 10) {
                                ForEach(filteredAlerts) { alert in
                                    NavigationLink(destination: AlertDetailView(alert: alert)) {
                                        VStack(alignment: .leading, spacing: 5) {
                                            HStack {
                                                Text(alert.title)
                                                    .font(.custom("Gordita-Bold", size: 18))
                                                    .foregroundColor(.primary)
                                                Spacer()
                                                VStack(alignment: .trailing) {
                                                    HStack {
                                                        Text("Severity:")
                                                            .foregroundColor(.primary)
                                                            .font(.custom("Gordita-Regular", size: 15))
                                                        Text(alert.severity)
                                                            .foregroundColor(color(for: alert.severity))
                                                            .bold()
                                                    }
                                                    Text("Status: \(alert.status)")
                                                        .foregroundColor(.white)
                                                        .font(.custom("Gordita-Regular", size: 15))
                                                }
                                            }
                                            Spacer()
                                            Text(formattedDateString(alert.createdAt))
                                                .font(.custom("Gordita-Regular", size: 15))
                                                .foregroundColor(Color("HTeal"))
                                        }
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color("Charcoal"))
                                    .cornerRadius(10)
                                    .padding(.vertical, 5)
                                }
                            }
                            .padding()
                        }
                    } else if let errorMessage = viewModel.errorMessage {
                        Text("Error: \(errorMessage)")
                            .foregroundColor(.red)
                            .padding()
                    } else {
                        Text("Loading...")
                    }
                }
                    .onAppear {
                        viewModel.fetchAlert(from: urlString, bearerToken: "226d5597-6efc-46e6-9dc1-11304ce1a9d5")
                    }
        }
    }
    // Filter controls UI
    private var filterControls: some View {
        VStack {
            Text("Alerts")
                .font(.custom("Gordita-Bold", size: 26))
            HStack {
                Menu {
                    ForEach(CreatedAtFilter.allCases, id: \.self) { filter in
                        Button(action: {
                            createdAtFilter = filter
                            print("Selected Date Filter: \(createdAtFilter.rawValue)")
                        }) {
                            Text(filter.rawValue)
                        }
                    }
                } label: {
                    Text("Date: \(createdAtFilter.rawValue)")
                        .padding(8)
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.white)
                        .font(.custom("Gordita-Regular", size: 18))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.teal, lineWidth: 1))
                }

                Menu {
                    ForEach(SeverityFilter.allCases, id: \.self) { filter in
                        Button(action: {
                            filterSeverity = filter
                            print("Selected Severity Filter: \(filterSeverity.rawValue)")
                        }) {
                            Text(filter.rawValue)
                        }
                    }
                } label: {
                    Text("Severity: \(filterSeverity.rawValue)")
                        .padding(8)
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.white)
                        .font(.custom("Gordita-Regular", size: 18))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.teal, lineWidth: 1))
                }

                Menu {
                    ForEach(StatusFilter.allCases, id: \.self) { filter in
                        Button(action: {
                            filterStatus = filter
                            print("Selected Status Filter: \(filterStatus.rawValue)")
                        }) {
                            Text(filter.rawValue)
                        }
                    }
                } label: {
                    Text("Status: \(filterStatus.rawValue)")
                        .padding(8)
                        .background(Color("Charcoal"))
                        .foregroundColor(.white)
                        .font(.custom("Gordita-Regular", size: 18))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color("HTeal"), lineWidth: 1))
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, -5)
    }

    // Computed property to filter alerts based on selected filters
    private var filteredAlerts: [Alert] {
        var alerts = viewModel.alerts

        // Filter by created_at
        let now = Date()
        switch createdAtFilter {
        case .last7Days:
            let last7Days = Calendar.current.date(byAdding: .day, value: -7, to: now)!
            print("Filtering alerts from last 7 days")
            alerts = alerts.filter { $0.createdAt >= last7Days }
        case .last24Hours:
            let last24Hours = Calendar.current.date(byAdding: .hour, value: -24, to: now)!
            print("Filtering alerts from last 24 hours")
            alerts = alerts.filter { $0.createdAt >= last24Hours }
        case .all:
            print("Showing all alerts")
            alerts = alerts.sorted { $0.createdAt > $1.createdAt }
        }

        // Filter by severity
        if filterSeverity != .all {
            print("Filtering by severity: \(filterSeverity.rawValue)")
            alerts = alerts.filter { $0.severity.lowercased() == filterSeverity.rawValue.lowercased() }
        }

        // Filter by status
        if filterStatus != .all {
            print("Filtering by status: \(filterStatus.rawValue)")
            alerts = alerts.filter { $0.status.lowercased() == filterStatus.rawValue.lowercased() }
        }

        return alerts
    }

    // Helper function to format Date to string
    private func formattedDateString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter.string(from: date)
    }

    // Helper function to determine color based on severity
    private func color(for severity: String) -> Color {
        switch severity.lowercased() {
        case "low":
            return .green
        case "medium":
            return .yellow
        case "high":
            return .red
        default:
            return .gray
        }
    }
}

// Define the Chart View
struct AlertChartView: View {
    let alerts: [Alert]

    var body: some View {
        VStack {
            Chart {
                ForEach(groupedAlertsByDateAndSeverity(), id: \.key) { (severity, alertsByDate) in
                    ForEach(alertsByDate, id: \.key) { date, count in
                        LineMark(
                            x: .value("Date", date),
                            y: .value("Count", count)
                        )
                        .foregroundStyle(by: .value("Severity", severity))
                        .symbol(by: .value("Severity", severity))
                    }
                }
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .day, count: 1)) { value in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel(anchor: .center) {
                        if let date = value.as(Date.self) {
                            Text(date, format: .dateTime.month(.twoDigits).day(.twoDigits))
                                .padding(.top, 10)
                        }
                    }
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading)
            }
            .frame(height: 150) // Adjust the chart height as needed
            .padding(.bottom, 10) // Add padding at the bottom to provide space for x-axis labels and legend
        }
        .padding()
    }

    private func groupedAlertsByDateAndSeverity() -> [(key: String, value: [(key: Date, value: Int)])] {
        let calendar = Calendar.current

        // Define the second week of July
        let components = DateComponents(year: 2024, month: 7, weekOfMonth: 2)
        guard let secondWeekStart = calendar.date(from: components) else { return [] }
        let secondWeekEnd = calendar.date(byAdding: .day, value: 6, to: secondWeekStart) ?? secondWeekStart

        let secondWeekAlerts = alerts.filter { alert in
            alert.createdAt >= secondWeekStart && alert.createdAt <= secondWeekEnd
        }

        let groupedBySeverity = Dictionary(grouping: secondWeekAlerts, by: \.severity)
        var result: [(key: String, value: [(key: Date, value: Int)])] = []

        for (severity, alerts) in groupedBySeverity {
            let groupedByDate = Dictionary(grouping: alerts, by: { calendar.startOfDay(for: $0.createdAt) })
            let sortedGroupedByDate = groupedByDate.map { (key: $0.key, value: $0.value.count) }.sorted { $0.key < $1.key }
            result.append((key: severity, value: sortedGroupedByDate))
        }

        return result
    }
}
