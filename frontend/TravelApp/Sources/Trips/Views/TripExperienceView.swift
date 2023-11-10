//
//  TripExperienceView.swift
//  TravelApp
//
//  Created by Rachel Pratt on 11/2/23.
//

import SwiftUI

struct TripExperienceView: View {
    var datedExperience: DatedExperience
    
    var body: some View {
        HStack() {
            Image("experience")
                .resizable()
                .frame(width: 50, height: 50)
            VStack(alignment: .leading) {
                Text(datedExperience.experience)
                    .font(.headline)
                
                Text("City, State") // 
                    .font(.subheadline)
            }
            Spacer()
        }
    }
}

#Preview {
    Group {
        TripExperienceView(datedExperience: DatedExperience(experience: "Example Experience", date: Date()))
                           
    }
}
