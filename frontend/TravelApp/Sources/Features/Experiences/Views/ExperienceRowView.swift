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
                
                Text(experience.location.state)
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
