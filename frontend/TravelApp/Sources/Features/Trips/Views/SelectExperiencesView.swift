//
//  SelectExperiencesView.swift
//  TravelApp
//
//  Created by Rachel Pratt on 11/24/23.
//

import SwiftUI


// Need to change this to select only experiences that belong to user
struct SelectExperiencesView: View {
    @Binding var selectedExperiences: Set<String>
    let allExperiences: [Experience]

    var body: some View {
        List(allExperiences, id: \.self) { experience in
            HStack {
                Text(experience.title)
                Spacer()
                if selectedExperiences.contains(experience.id) {
                    Image(systemName: "checkmark")
                }
            }
            .onTapGesture {
                if selectedExperiences.contains(experience.id) {
                    selectedExperiences.remove(experience.id)
                } else {
                    selectedExperiences.insert(experience.id)
                }
            }
        }
    }
}
