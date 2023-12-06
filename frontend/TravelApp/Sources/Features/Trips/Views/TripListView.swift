//
//  TripListView.swift
//  TravelApp
//
//  Created by Rachel Pratt on 11/2/23.
//

import SwiftUI

struct TripListView: View {
    @State private var searchText: String = ""
    @State private var trips: [Trip] = []
    @EnvironmentObject var userViewModel:  UserViewModel
    private var userData: UserModel? {
        userViewModel.getSessionData()?.userData
        
    }
    
    var filteredResults: [Trip] {
        if searchText.isEmpty {
            return trips
        } else {
            return trips.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredResults, id: \.id) { trip in
                    NavigationLink {
                        TripDetailView(trip: trip)
                    } label: {
                        TripRowView(trip: trip)
                    }
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
