//
//  TripDetailView.swift
//  TravelApp
//
//  Created by Rachel Pratt on 11/2/23.
//

import SwiftUI

struct TripDetailView: View {
    var trip: Trip
    
    // Map dates to experiences
//    private func experiencesByDate() -> [Date: [DatedExperience]] {
//        var experiencesByDate = [Date: [DatedExperience]]()
//        
//        for experience in trip.experiences {
//            experiencesByDate[experience.date, default: []].append(experience)
//        }
//        
//        return experiencesByDate
//    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                HStack{
                    Text(trip.name)
                        .font(.title).bold()
                    Spacer()
                    // The following edit button should ONLY be visible
                    // if the viewing user is the creator of the trip
                    NavigationLink(destination: TripEditView(trip: trip)) {
                                            Image("edit")
                                                .resizable()
                                                .frame(width: 24, height: 24)
                                        }
                }
                
                HStack {
                    Image("user")
                        .resizable()
                        .frame(width: 15, height:15)
                    Text(trip.user) //User name will go here
                        .font(.footnote)
                }

                
                Text(trip.formattedDateRange)
                    .font(.callout)
                
                Divider()
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Description")
                        .font(.title3).bold()
                
                    Text(trip.description)
                }
                
                Divider()
                
                // Iterate over the dates and display experiences for each date
//                let sortedDates = experiencesByDate().keys.sorted()
//                ForEach(sortedDates, id: \.self) { date in
//                    VStack(alignment: .leading) {
//                        Text(date, style: .date)
//                            .font(.headline)
//                            .padding(.vertical, 2)
//                        
//                        ForEach(experiencesByDate()[date] ?? [], id: \.self) { datedExperience in
//                            TripExperienceView(datedExperience: datedExperience)
//                        }
//                        Spacer(minLength: 20)
//                    }
//                }
            }
            .padding()
        }
    }
}

#Preview {
    TripDetailView(trip: Trip(id: "1234", name: "Sample Trip", description: "Description", startDate: Date(), endDate: Date(), user: "Sample User"))
}
