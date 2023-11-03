//
//  ExperienceRowView.swift
//  TravelApp
//
//  Created by Bryshon Sweeney on 10/25/23.
//

import SwiftUI

struct ExperienceRowView: View {
    var experience: Experience
    
    var body: some View {
        HStack() {
            Image("charleyrivers")
                .resizable()
                .frame(width: 50, height: 50)
            VStack {
                Text(experience.title)
                    .font(.headline)
                
                Text("California")
                    .font(.subheadline)
            }
            Spacer()
        }
    }
}

#Preview {
    Group {
        ExperienceRowView(experience: experiences[0])
        ExperienceRowView(experience: experiences[1])
    }
   
}
