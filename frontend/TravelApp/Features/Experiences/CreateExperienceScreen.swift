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
    @State private var city = ""
    @State private var state = ""
    @State private var rating = 4
    @State private var date: Date = Date()
    @State private var keywords: [String] = []
    @State private var photoPickerItem: PhotosPickerItem?
    @State private var experienceImage: UIImage?
    @State private var newExperience: NewExperience?
    var api = ExperienceAPI()
    
    
    
    private let separator: String = "\r\n"
    private var data: Data = Data()
    
    var body: some View {
        VStack(spacing: 20) {
            
            // Inputs
            CreateInputView(text: $title, placeholder: "Enter title name", label: "Title")
            CreateInputView(text: $description, placeholder: "Enter description", label: "Description", isLongText: true)
            CreateInputView(text: $city, placeholder: "Enter city", label: "City")
            CreateInputView(text: $state, placeholder: "Enter state", label: "State")
            
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
                    print(rating)
                    newExperience = NewExperience(title: title, description: description, state: state, city: city, rating: rating + 1, keywords: keywords, date: date)
                    self.createExperience(objectName: "experience", object: newExperience!)
                    dismiss()
                } label: {
                    Text("Save")
                        .fontWeight(.semibold)
                    
                }
                .foregroundColor(.white)
                .frame(width: 100, height: 40)
                .background(title.isEmpty || description.isEmpty || city.isEmpty || state.isEmpty || (experienceImage == nil) ? Color.gray : Color.black)
                .border(Color.white)
                .disabled(title.isEmpty || description.isEmpty || city.isEmpty || state.isEmpty || (experienceImage == nil))
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
    // METHODS
    func createExperience(objectName: String, object: NewExperience) {
        let requestBody = api.multipartFormDataBody(objectName, object, experienceImage!)
        let request = api.generateRequest(httpBody: requestBody)
        
        URLSession.shared.dataTask(with: request) { data, resp, error in
            if let error = error {
                print(error)
                return
            }
            
            print(String(data: data!, encoding: .utf8 )!)
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
