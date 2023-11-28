//
//  EditExperienceView.swift
//  TravelApp
//
//  Created by Bryshon Sweeney on 11/16/23.
//

import SwiftUI
import PhotosUI

struct EditExperienceView: View {
    // DONT FORGET TO ADD USERID TO THE NEWEXPERIENCE MODEL AND HERE AS WELL!!
    @Environment(\.dismiss) var dismiss
    @Binding var experience: Experience
    @State var title = ""
    @State var description = ""
    @State var location: Location = Location()
//    @State var city = ""
//    @State var state = ""
    @State var rating = 4
    @State var date: Date = Date()
    @State var keywords: [String] = []
    @State var photoPickerItem: PhotosPickerItem?
    @State var experienceImage: UIImage?
    var api = ExperienceAPI()
    
    
    
//    private let separator: String = "\r\n"
//    private var data: Data = Data()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                // Inputs
                CreateInputView(text: $title, placeholder: "Enter title name", label: "Title")
                CreateInputView(text: $description, placeholder: "Enter description", label: "Description", isLongText: true)
                NavigationLink {
                    SearchView(location: $location)
                } label: {
                    HStack {
                        Text("Search Location")
                        Image(systemName: "magnifyingglass")
                    }
                }
                VStack (alignment: .leading, spacing: 6) {
                    Text("City")
                        .foregroundStyle(Color(.black))
                        .fontWeight(.semibold)
                        .font(.subheadline)
                    Text("\(location.city)")
                        .padding(.horizontal, 4)
                        .padding(.vertical, 7)
                        .font(.system(size: 14))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .border(Color(.darkGray))
                }
                
                VStack (alignment: .leading) {
                    Text("State")
                        .foregroundStyle(Color(.black))
                        .fontWeight(.semibold)
                        .font(.subheadline)
                    Text("\(location.state)")
                        .padding(.horizontal, 4)
                        .padding(.vertical, 7)
                        .font(.system(size: 14))
                        .frame(maxWidth:.infinity, alignment: .leading)
                        .border(Color(.darkGray))
                }
                
                // Date
                DatePicker("Date", selection: $date, displayedComponents: .date)
                
                
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
                
                // Image
                HStack {
                    PhotosPicker(selection: $photoPickerItem, matching: .images) {
                        Text("Select an image")
                    }
                    Spacer()
                    if experienceImage == nil {
                        AsyncImage(url: URL(string: experience.imageUrl)) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                        .clipped()
                                } else if phase.error != nil {
                                    Text("There was an error loading the image.")
                                } else {
                                    ProgressView()
                                }
                            }
                        
                    } else {
                        Image(uiImage: experienceImage!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                    }
                    
                    Spacer()
                }
                
                
                // Buttons
                HStack(spacing: 40) {
                    // Cancel Button
                    Button {
                        DispatchQueue.main.async {
                            dismiss()
                        }
                    } label: {
                        Text("Cancel")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.black)
                    .frame(width: 100, height: 40)
                    .border(Color.black)
                    
                    // Save Button
                    Button {
                        // id, title, description, state, city, rating, keywords, date
                        self.createKeywords()
                        let updatedExperience = Experience(id: experience.id, title: title, description: description, rating: rating, keywords: keywords, date: Int(date.timeIntervalSinceReferenceDate), location:location,  imageUrl: experience.imageUrl)
                        self.updateExperience(objectName: "experience", object: updatedExperience)
                    } label: {
                        Text("Save")
                            .fontWeight(.semibold)
                        
                    }
                    .foregroundColor(.white)
                    .frame(width: 100, height: 40)
                    .background(title.isEmpty || description.isEmpty || location.city.isEmpty || location.state.isEmpty ? Color.gray : Color.black)
                    .border(Color.white)
                    .disabled(title.isEmpty || description.isEmpty || location.city.isEmpty || location.state.isEmpty)
                }
                .padding(.vertical)
            }
            .onChange(of: photoPickerItem, { _, _ in
                Task {
                    if let photoPickerItem,
                       let data = try? await photoPickerItem.loadTransferable(type: Data.self) {
                        if let image = UIImage(data: data) {
                            experienceImage = image
                        }
                    }
                }
            })
            .padding()
            .onAppear {
                self.title = experience.title
                self.description = experience.description
                self.location = experience.location
//                self.city = experience.city
//                self.state = experience.state
                self.rating = experience.rating
                self.date = Date(timeIntervalSinceReferenceDate: TimeInterval(experience.date))
                
            }
            
            Spacer()
        }
        
    }
    // METHODS
    func updateExperience(objectName: String, object: Experience) {
        let requestBody = api.multipartFormDataBodyUpdateExperience(objectName, object, experienceImage)
        let request = api.generateUpdateRequest(httpBody: requestBody, httpMethod: .post, id: experience.id)
        
        URLSession.shared.dataTask(with: request) { data, resp, error in
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
    
    func createKeywords() {
        keywords += title.components(separatedBy: " ")
        keywords += description.components(separatedBy: " ")
    }
}

#Preview {
    EditExperienceView(experience: .constant(experiences[0]))
}
