//
//  SearchView.swift
//  TravelApp
//
//  Created by Bryshon Sweeney on 11/21/23.
//

import SwiftUI
import MapKit

struct SearchView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var places: [Place] = []
    @State private var searchText = ""
    @Binding var location: Location
    
    var body: some View {
        NavigationStack {
            List(places) { place in
                VStack(alignment: .leading) {
                    Text("Name: \(place.name)")
                        .font(.title2)
                    Text("City: \(place.city), State: \(place.state)")
                }
                .onTapGesture {
                    location.city = place.city
                    location.state = place.state
                    location.latitude = place.latitude
                    location.longitude = place.longitude
                    dismiss()
                }
                
            }
            .onChange(of: searchText) {
                self.search(text: searchText)
            }
            .listStyle(.plain)
            .searchable(text: $searchText)
        }
    }
    func search(text: String) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = text
        
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "Unknown Error")")
                return
            }
            
            self.places = response.mapItems.map(Place.init)
        }
    }
}

#Preview {
    SearchView(location: .constant(Location()))
}

