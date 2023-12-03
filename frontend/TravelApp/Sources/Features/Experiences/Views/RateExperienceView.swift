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
    var userData: UserModel {
        userViewModel.getSessionData()!.userData
    }
    @Binding var experience: Experience
    @State private var rating: Int = 5
    var api = ExperienceAPI()
    var body: some View {
        VStack(spacing: 40) {
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
                print("Rated Experience")
                let updatedExperience = Experience(id: experience.id, title: experience.title, description: experience.description, rating: rating, keywords: experience.keywords, date: experience.date, location:experience.location,  imageUrl: experience.imageUrl, userID: experience.userID, ratings: experience.ratings)
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
        
    }
    
    func rateExperience() {
        guard let url = URL(string: "\(api.developmentUrl)\(self.experience.id)/rate") else {fatalError("Missing URL")}
        let encoder = JSONEncoder()
        guard let bodyData = try? encoder.encode(self.experience) else {
            print("Error")
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = bodyData
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
}
