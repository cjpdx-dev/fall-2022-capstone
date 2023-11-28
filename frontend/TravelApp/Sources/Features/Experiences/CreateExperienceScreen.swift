//
//  CreateExperienceScreen.swift
//  TravelApp
//
//  Created by Bryshon Sweeney on 10/30/23.
//

import SwiftUI
import PhotosUI

struct CreateExperienceScreen: View {
    // DONT FORGET TO ADD USERID TO THE NEWEXPERIENCE MODEL AND HERE AS WELL!!
    @Environment(\.dismiss) var dismiss
    @State private var title = ""
    @State private var description = ""
    @State private var rating = 4
    @State private var date: Date = Date()
    @State private var keywords: [String] = []
    @State private var photoPickerItem: PhotosPickerItem?
    @State private var experienceImage: UIImage?
    @State private var newExperience: NewExperience?
    @State private var location: Location = Location()
    @EnvironmentObject var userData: UserViewModel
    var api = ExperienceAPI()
    
    
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
                    Image(uiImage: experienceImage ?? UIImage(resource: .default))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                    Spacer()
                }
                
                
                // Buttons
                HStack(spacing: 40) {
                    // Cancel Button
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.black)
                    .frame(width: 100, height: 40)
                    .border(Color.black)
                    
                    // Save Button
                    Button {
                        self.createKeywords()
//                        newExperience = NewExperience(title: title, description: description, location: location, rating: rating, keywords: keywords, date: date)
                        newExperience = NewExperience(userID: (userData.getSessionData()?.userData.id)!, title: title, description: description, location: location, rating: rating, keywords: keywords, date: date)
                        self.createExperience(objectName: "experience", object: newExperience!)
                        
                    } label: {
                        Text("Save")
                            .fontWeight(.semibold)
                        
                    }
                    .foregroundColor(.white)
                    .frame(width: 100, height: 40)
                    .background(title.isEmpty || description.isEmpty || location.city.isEmpty || location.state.isEmpty || (experienceImage == nil) ? Color.gray : Color.black)
                    .border(Color.white)
                    .disabled(title.isEmpty || description.isEmpty || location.city.isEmpty || location.state.isEmpty || (experienceImage == nil))
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
            
            Spacer()
        }
        
    }
    // METHODS
    func createExperience(objectName: String, object: NewExperience) {
        let requestBody = api.multipartFormDataBodyNewExperience(objectName, object, experienceImage!)
        let request = api.generateCreateRequest(httpBody: requestBody, httpMethod: .post)
        
        URLSession.shared.dataTask(with: request) { data, resp, error in
            if let error = error {
                print(error)
                return
            }
            DispatchQueue.main.async {
                dismiss()
                print(String(data: data!, encoding: .utf8 )!)
            }
        }.resume()
            
    }
    
    func createKeywords() {
        keywords += title.components(separatedBy: " ")
        keywords += description.components(separatedBy: " ")
    }
}


#Preview {
    CreateExperienceScreen()
}
