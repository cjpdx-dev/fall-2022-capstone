//
//  TripDetailView.swift
//  TravelApp
//
//  Created by Rachel Pratt on 11/2/23.
//

import SwiftUI

struct TripDetailView: View {
    @Binding var trip: Trip
    @State private var tripIsDeleted = false
    @State private var sortedExperiences = [Date: [Experience]]()
    
    private func getAndSortExperiences() {
        let api = TripsAPI()
        var experiences = [Experience]()
        let group = DispatchGroup()
        for id in trip.experiences {
            group.enter()
            api.getExperience(experienceId: id) { experience in
                if let experience = experience {
                    experiences.append(experience)
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            sortedExperiences = [:]
            for experience in experiences {
                let date = Date(timeIntervalSinceReferenceDate: TimeInterval(experience.date))
                sortedExperiences[date, default: []].append(experience)
            }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                HStack{
                    Text(trip.name)
                        .font(.title).bold()
                    Spacer()
                    // The following edit button should ONLY be visible
                    // if the viewing user is the creator of the trip
                    NavigationLink(destination: TripEditView(trip: $trip, onTripUpdated: {
                    })) {
                        Image("edit")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                }
                HStack {
                    Image("user")
                        .resizable()
                        .frame(width: 15, height:15)
                    Text(trip.user ?? "Unknown user")
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
                
                ForEach(Array(sortedExperiences.keys.sorted()), id: \.self) { date in
                    VStack(alignment: .leading) {
                        Text(date, style: .date)
                            .font(.headline)
                            .padding(.vertical, 2)
                        ForEach(sortedExperiences[date] ?? [], id: \.id) { experience in
                            NavigationLink(destination: ExperienceDetailView(experience: experience)) {
                                TripExperienceView(experience: experience)
                            }
                        }
                    }
                }
            }.padding()
        }
        .onAppear {
            getAndSortExperiences()
        }
    }
}

struct TripDetailView_Previews: PreviewProvider {
    @State static var previewTrip = Trip(id: "1234", name: "Sample Trip", description: "Description", startDate: Date(), endDate: Date(), user: "Sample User", experiences: [])

    static var previews: some View {
        TripDetailView(trip: $previewTrip)
    }
}
