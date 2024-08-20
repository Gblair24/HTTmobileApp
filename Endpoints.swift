//
//  Endpoints.swift
//  VoltGo
//
//  Created by Grady Blair on 6/27/24.
//

import SwiftUI
import Foundation
import Charts


struct Endpoints: Identifiable, Equatable {
    public let id: Int
    public let name: String
    public let EndpointCount: Int
    public let Osys: String
    
    static var examples = [
        Endpoints(id: 1, name: "Endpoint1", EndpointCount: 5, Osys: "Mac"),
        Endpoints(id: 2, name: "Endpoint2", EndpointCount: 8, Osys: "Windows"),
        Endpoints(id: 3, name: "Endpoint3", EndpointCount: 9, Osys: "Mac"),
        Endpoints(id: 4, name: "Endpoint1", EndpointCount: 15, Osys: "Linux"),
        Endpoints(id: 5, name: "Endpoint2", EndpointCount: 12, Osys: "Windows"),
        Endpoints(id: 6, name: "Endpoint3", EndpointCount: 7, Osys: "Linux"),
        Endpoints(id: 7, name: "Endpoint1", EndpointCount: 3, Osys: "Mac"),
        Endpoints(id: 8, name: "Endpoint2", EndpointCount: 18, Osys: "Linux"),
        Endpoints(id: 9, name: "Endpoint3", EndpointCount: 11, Osys: "Windows")
    ]
}

struct EndpointsTableView: View {
    let topEndpoints = Endpoints.examples.prefix(3)
    
    var body: some View {
        ScrollView(.horizontal) {
            VStack(alignment: .leading) {
                HStack {
                    Text("ID").bold().frame(width: 50).padding(.horizontal)
                    Text("Name").bold().frame(width: 100).padding(.horizontal)
                    Text("Count").bold().frame(width: 50).padding(.horizontal)
                    Text("OS").bold().frame(width: 100).padding(.horizontal)
                }
                Divider().background(Color.white)
                ForEach(topEndpoints) { endpoint in
                    HStack {
                        Text("\(endpoint.id)").frame(width: 50).padding(.horizontal)
                        Text("\(endpoint.name)").frame(width: 100).padding(.horizontal)
                        Text("\(endpoint.EndpointCount)").frame(width: 50).padding(.horizontal)
                        Text("\(endpoint.Osys)").frame(width: 100).padding(.horizontal)
                    }
                    Divider().background(Color.white)
                }
            }
            .padding()
        }
    }
}

struct EndpointsChartView: View {
    let endpoints: [Endpoints]
    
    var body: some View {
        Chart(endpoints) { endpoint in
            BarMark(
                x: .value("OS", endpoint.Osys),
                y: .value("Count", endpoint.EndpointCount)
            )
            .foregroundStyle(by: .value("OS", endpoint.Osys))
        }
        .chartForegroundStyleScale([
            "Mac": Color("HTeal"), "Windows": .indigo, "Linux": Color("HOrange")
        ])
        .chartXAxis {
            AxisMarks(values: .automatic) { value in
                AxisGridLine()
                    .foregroundStyle(Color.white)
                AxisTick()
                    .foregroundStyle(Color.white)
                AxisValueLabel()
                    .foregroundStyle(Color.white)
            }
        }
    }
}
