//
//  TripScreen.swift
//  TravelApp
//
//  Created by Rachel Pratt on 11/2/23.
//

import SwiftUI

struct TripScreen: View {
    var trips: [Trip]
    var body: some View {
        NavigationView{
            TripListView(trips: trips)
        }
    }
}

#Preview {
    TripScreen(trips: trips)
}

