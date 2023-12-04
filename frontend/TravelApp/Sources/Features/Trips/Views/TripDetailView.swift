//
//  TripDetailView.swift
//  TravelApp
//
//  Created by Rachel Pratt on 11/2/23.
//

import SwiftUI

struct TripDetailView: View {
    @State var trip: Trip
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var tripIsDeleted = false
    @State private var sortedExperiences = [Date: [Experience]]()
    @State var tripCreatorUsername: String = ""
    var userApi = UserAPI()
    var userID: String {
        userViewModel.getSessionData()?.userData.id ?? ""
    }
    var token: String {
        userViewModel.getSessionData()?.userData.token ?? ""
    }
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
                    if userID == trip.user {
                        NavigationLink(destination: TripEditView(trip: $trip, onTripUpdated: {
                        })) {
                            Image("edit")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                    }
                }
                HStack {
                    Image("user")
                        .resizable()
                        .frame(width: 15, height:15)
                    Text(tripCreatorUsername)
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
                if let tripUserId = trip.user {
                    getUsernameOfTripCreator(tripUserId: tripUserId)
                } else {
                    print("No user ID for this Trip")
                }
            }
    }
    
    func getUsernameOfTripCreator(tripUserId: String) {
        guard let url = URL(string: "\(userApi.baseURL)/users/\(tripUserId)/public") else { fatalError("Missing URL") }
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "GET"

        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }
            guard let response = response as? HTTPURLResponse else { return }
            
            if response.statusCode == 200 {
                guard let data = data else { return }
                DispatchQueue.main.async {
                    do {
                        let decoder = JSONDecoder()
                        let decodedUser = try decoder.decode(UserModel.self, from: data)
                        tripCreatorUsername = decodedUser.displayName
                    } catch let error {
                        print("Error decoding: ", error)
                    }
                }
            }
        }
        dataTask.resume()
    }
}

//struct TripDetailView_Previews: PreviewProvider {
//    @State static var previewTrip = Trip(id: "1234", name: "Sample Trip", description: "Description", startDate: Date(), endDate: Date(), user: "Sample User", experiences: [])
//
//    static var previews: some View {
//        TripDetailView(trip: $previewTrip)
//    }
//}
