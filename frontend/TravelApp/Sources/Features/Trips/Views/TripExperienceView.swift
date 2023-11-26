//
//  TripExperienceView.swift
//  TravelApp
//
//  Created by Rachel Pratt on 11/2/23.
//
//
import SwiftUI

struct TripExperienceView: View {
    var experience: Experience
    var body: some View {
        HStack {
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
                    .foregroundColor(.black)
                
                Text(experience.city)
                    .font(.subheadline)
                    .foregroundColor(.black)
            }
            Spacer()
        }
    }
}

#Preview {
    Group {
        TripExperienceView(experience: experiences[0])
    }
}
