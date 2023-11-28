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
    
    // This is the user session
    @EnvironmentObject var userViewModel:  UserViewModel
    // This is the user's data that is pulled from the user's session
    // You could access the session token "token" by calling...
    //      token = userData.token
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
                ForEach(filteredResults, id: \.id) { filteredTrip in
                    if let index = trips.firstIndex(where: { $0.id == filteredTrip.id }) {
                        let bindingTrip = $trips[index]
                        NavigationLink {
                            TripDetailView(trip: bindingTrip)
                        } label: {
                            TripRowView(trip: bindingTrip.wrappedValue)
                        }
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
