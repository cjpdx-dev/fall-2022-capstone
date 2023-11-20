//
//  TripListView.swift
//  TravelApp
//
//  Created by Rachel Pratt on 11/2/23.
//

import SwiftUI

struct TripListView: View {
//    @Binding var selectedTrip: Trip?
    @State private var searchText: String = ""
    @State private var trips: [Trip] = []

    var body: some View {
        NavigationStack {
            List {
                ForEach($trips, id: \.id) { $trip in
                    NavigationLink {
                        TripDetailView(trip: $trip)
                    } label: {
                        TripRowView(trip: $trip.wrappedValue)
                    }
                }
            }
//            List(trips, id: \.id) { trip in
//                Button(action: {
//                    selectedTrip = trip
//                }) {
//                    TripRowView(trip: trip)
//                }
//            }
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
            .onAppear {
                TripsAPI().getTrips { fetchedTrips in
                    self.trips = fetchedTrips
                }
            }
        }
    }
}

#Preview {
    TripListView()
}
