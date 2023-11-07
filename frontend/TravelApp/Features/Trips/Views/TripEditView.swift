//
//  TripEditView.swift
//  TravelApp
//
//  Created by Rachel Pratt on 11/2/23.
//

import SwiftUI

struct TripEditView: View {
    var trip: Trip
    var body: some View {
        Text("Editing trip: \(trip.name)")
    }
}

#Preview {
    TripEditView(trip: trips[0])
}
