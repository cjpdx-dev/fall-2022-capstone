//
//  SelectExperiencesView.swift
//  TravelApp
//
//  Created by Rachel Pratt on 11/24/23.
//

import SwiftUI


struct SelectExperiencesView: View {
    @Binding var selectedExperiences: Set<String>
    @EnvironmentObject var userViewModel: UserViewModel
    let allExperiences: [Experience]
    let tripStartDate: Date
    let tripEndDate: Date
    @Binding var alertMessage: String
    @Binding var showingAlert: Bool
    
    var userID: String {
        userViewModel.getSessionData()?.userData.id ?? ""
    }
    
    var userExperiences: [Experience] {
        allExperiences.filter { $0.userID == userID }
    }

    var body: some View {
        List(userExperiences, id: \.self) { experience in
            HStack {
                VStack(alignment: .leading) {
                        Text(experience.title)
                            .font(.headline)
                        Text(Date(timeIntervalSinceReferenceDate: TimeInterval(experience.date)), style: .date)
                            .font(.subheadline)
                    }
                Spacer()
                if selectedExperiences.contains(experience.id) {
                    Image(systemName: "checkmark")
                }
            }
            .onTapGesture {
                let experienceDate = Date(timeIntervalSinceReferenceDate: TimeInterval(experience.date))
                if experienceDate >= tripStartDate && experienceDate <= tripEndDate {
                    toggleSelection(for: experience)
                } else {
                    alertMessage = "Selected experiences must have date within the trip's date range."
                    showingAlert = true
                }
            }
        }
    }
    private func toggleSelection(for experience: Experience) {
            if selectedExperiences.contains(experience.id) {
                selectedExperiences.remove(experience.id)
            } else {
                selectedExperiences.insert(experience.id)
            }
        }
}
