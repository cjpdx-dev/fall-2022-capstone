//
//  ExperienceRowView.swift
//  TravelApp
//
//  Created by Bryshon Sweeney on 10/25/23.
//

import SwiftUI

struct ExperienceRowView: View {
    var experience: Experience
    @State var userOfExperience: String = ""
    @EnvironmentObject var userViewModel: UserViewModel
    var userApi = UserAPI()
    var userName: String {
        userViewModel.getSessionData()?.userData.displayName ?? ""
    }
    var token: String {
        userViewModel.getSessionData()?.userData.token ?? ""
    }
    
    var body: some View {
        HStack() {
//            experience.image
            AsyncImage(url: URL(string: experience.imageUrl)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .clipped()
                    } else if phase.error != nil {
                        Text("There was an error loading the image.")
                    } else {
                        ProgressView()
                    }
                }
                .frame(width: 50, height: 50)
            VStack(alignment: .leading) {
                Text(experience.title)
                    .font(.headline)
                
                Text("\(experience.location.city), \(experience.location.state)")
                    .font(.subheadline)
                Text("Created by: \(userOfExperience != "" ? userOfExperience : "User Information Private")")
                    .font(.caption)
            }
            Spacer()
        }
        .onAppear {
            getUserOfExperience()
        }
    }
    func getUserOfExperience() {
        guard let url = URL(string: "\(userApi.baseURL)/users/\(experience.userID)/public") else {fatalError("Missing URL")}
        var urlRequest = URLRequest(url: url)
//        let urlRequest = URLRequest(url: productionUrl)
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "GET"
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }
            guard let response = response as? HTTPURLResponse else {return}
            
            if response.statusCode == 200 {
                guard let data = data else {return}
                DispatchQueue.main.async {
                    do {
                        let decoder = JSONDecoder()
                        let decodedUser = try decoder.decode(UserModel.self, from: data)
                        userOfExperience = decodedUser.displayName
                    } catch let error {
                        print("Error decoding: ", error)
                    }
                }
            }
        }
        dataTask.resume()
    }
}

#Preview {
    Group {
        ExperienceRowView(experience: experiences[0])
        ExperienceRowView(experience: experiences[1])
    }
   
}
