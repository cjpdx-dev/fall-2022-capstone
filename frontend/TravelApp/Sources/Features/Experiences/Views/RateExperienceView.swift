//
//  RateExperienceView.swift
//  TravelApp
//
//  Created by Bryshon Sweeney on 12/2/23.
//

import SwiftUI

struct RateExperienceView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userViewModel: UserViewModel
    @Binding var experience: Experience
    @State private var rating: Int = 5
    var userData: UserModel {
        userViewModel.getSessionData()!.userData
    }
    var userID: String {
        userViewModel.getSessionData()?.userData.id ?? ""
    }
    var token: String {
        userViewModel.getSessionData()?.userData.token ?? ""
    }
    var experienceApi = ExperienceAPI()
    var body: some View {
        VStack(spacing: 40) {
            //User's Previous Rating
            if experience.ratings[userID] != nil {
                Text("Previous Rating: \(experience.ratings[userID]! + 1)")
            } else {
                Text("Previous Rating: N/A")
            }
            // Rating
            HStack {
                Text("Rating")
                Spacer()
                Picker("Rating", selection: $rating) {
                    ForEach(1..<6) {
                        Text("\($0)")
                    }
                }.pickerStyle(.segmented)
                
                
            }
            // Save Button
            Button {
                self.experience = Experience(id: experience.id, title: experience.title, description: experience.description, rating: experience.rating, keywords: experience.keywords, date: experience.date, location:experience.location,  imageUrl: experience.imageUrl, userID: experience.userID, ratings: experience.ratings)
                self.experience.ratings.updateValue(rating, forKey: userID)
                self.rateExperience()
            } label: {
                Text("Rate")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(width: 100, height: 40)
                    .background(rating > 4 ? Color.gray : Color.black)
                    .border(Color.white)
                    .disabled(rating > 4)
                    .cornerRadius(12)
            }
            .disabled(rating > 4)
        }
        .padding()
        
    }
    
    func rateExperience() {
        
        guard let url = URL(string: "\(experienceApi.productionUrl)\(self.experience.id)/rate") else {fatalError("Missing URL")}
        let encoder = JSONEncoder()
        guard let bodyData = try? encoder.encode(self.experience) else {
            print("Error")
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = bodyData
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: urlRequest) { data, resp, error in
            if let error = error {
                print(error)
                return
            }
//             Decode data to an experience object
            guard let response = resp as? HTTPURLResponse else {return}
            
            if response.statusCode == 200 {
                guard let data = data else {return}
                DispatchQueue.main.async {
                    do {
                        let decoder = JSONDecoder()
                        let decodedExperience = try decoder.decode(Experience.self, from: data)
                        self.experience = decodedExperience
                        dismiss()
                    } catch let error {
                        print("Error decoding: ", error)
                    }
                }
            }
            // Change experience to updatedExperience
            print(String(data: data!, encoding: .utf8 )!)
            
        }.resume()
    }
}

#Preview {
    RateExperienceView(experience: .constant(experiences[0]))
        .environmentObject(UserViewModel())
}
