//
//  TripListView.swift
//  TravelApp
//
//  Created by Rachel Pratt on 11/2/23.
//

import SwiftUI

struct TripListView: View {
    @State private var searchText: String = ""
    var trips: [Trip]
    var body: some View {
        NavigationStack {
            List(trips) { trip in
                NavigationLink {
                    TripDetailView(trip: trip)
                } label: {
                    TripRowView(trip: trip)
                }
                
            }
            .navigationTitle("Trips")
            
            .toolbar(content: {
                NavigationLink {
                    CreateTripScreen()
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 27))
                }
                .buttonStyle(PlainButtonStyle())
                
            })
            .searchable(text: $searchText)
        }
        
    }
}

#Preview {
    TripListView(trips: trips)
}
