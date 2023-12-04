//
//  TripRowView.swift
//  TravelApp
//
//  Created by Rachel Pratt on 11/2/23.
//

import SwiftUI

struct TripRowView: View {
    var trip: Trip
    var userApi = UserAPI()
    @State var tripCreatorUsername: String = ""
    @EnvironmentObject var userViewModel: UserViewModel
    var userID: String {
        userViewModel.getSessionData()?.userData.id ?? ""
    }
    var token: String {
        userViewModel.getSessionData()?.userData.token ?? ""
    }
    
    var body: some View {
        HStack() {
            Image("trip")
                .resizable()
                .frame(width: 50, height: 50)
            VStack(alignment: .leading) {
                Text(trip.name)
                    .font(.headline)
                
                Text(trip.formattedDateRange)
                    .font(.subheadline)

                Text("Created by: \(tripCreatorUsername)")
                    .font(.caption)
            }
            Spacer()
        }
        .onAppear {
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
