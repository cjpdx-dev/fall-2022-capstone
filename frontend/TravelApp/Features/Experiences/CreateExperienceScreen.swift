//
//  CreateExperienceScreen.swift
//  TravelApp
//
//  Created by Bryshon Sweeney on 10/30/23.
//

import SwiftUI

struct CreateExperienceScreen: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
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
        }
    }
}

#Preview {
    CreateExperienceScreen()
}
