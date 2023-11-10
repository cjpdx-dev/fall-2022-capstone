//
//  CreateExperienceScreen.swift
//  TravelApp
//
//  Created by Bryshon Sweeney on 10/30/23.
//

import SwiftUI

struct CreateExperienceScreen: View {
    @Environment(\.dismiss) var dismiss
    @State private var title = ""
    @State private var description = ""
    @State private var city = ""
    @State private var state = ""
    var body: some View {
        VStack(spacing: 20) {
            CreateInputView(text: $title, placeholder: "Enter title name", label: "Title")
            CreateInputView(text: $description, placeholder: "Enter description", label: "Description", isLongText: true)
            CreateInputView(text: $city, placeholder: "Enter city", label: "City")
            CreateInputView(text: $state, placeholder: "Enter state", label: "State")
            CreateInputView(text: $title, placeholder: "Enter title name", label: "Photos")
            
            HStack(spacing: 40) {
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.black)
                .frame(width: 100, height: 40)
                .border(Color.black)
                
                
                
                Button {
                    print("Saved Experience!")
                } label: {
                    Text("Save")
                        .fontWeight(.semibold)
                    
                }
                .foregroundColor(.white)
                .frame(width: 100, height: 40)
                .background(Color.black)
                .border(Color.white)
                
            }
            .padding(.vertical)
        }
        .padding()
        
        Spacer()
    }
}

#Preview {
    CreateExperienceScreen()
}
