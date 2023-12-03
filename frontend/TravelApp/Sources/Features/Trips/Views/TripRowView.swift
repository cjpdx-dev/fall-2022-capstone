//
//  TripRowView.swift
//  TravelApp
//
//  Created by Rachel Pratt on 11/2/23.
//

import SwiftUI

struct TripRowView: View {
    var trip: Trip
    
    var body: some View {
        HStack() {
            Image("trip")
                .resizable()
                .frame(width: 50, height: 50)
            VStack(alignment: .leading) {
                Text(trip.name)
                    .font(.headline)
                
//                Text(trip.formattedDateRange)
                Text(trip.user ?? "Unknown user")
                    .font(.subheadline)
            }
            Spacer()
        }
    }
}

//#Preview {
//    Group {
//        TripRowView(trip: Trip(id: "1234", name: "Sample Trip", description: "Description", startDate: Date(), endDate: Date(), user: "Sample User", experiences: []))
//    }
//   
//}
