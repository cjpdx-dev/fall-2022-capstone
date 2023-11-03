//
//  ExperienceDetailView.swift
//  TravelApp
//
//  Created by Bryshon Sweeney on 10/25/23.
//

import SwiftUI

struct ExperienceDetailView: View {
    var experience: Experience
    var body: some View {
        Text(experience.title)
        Text(experience.description)
        Text("\(experience.rating)")
    }
}

#Preview {
    ExperienceDetailView(experience: experiences[0])
}

