//
//  TripEditView.swift
//  TravelApp
//
//  Created by Rachel Pratt on 11/2/23.
//

import SwiftUI

enum ActiveAlert: Identifiable {
    case experienceValidation, deleteConfirmation
    var id: Self { self }
}

struct TripEditView: View {
    @Binding var trip: Trip
    @Binding var tripIsDeleted: Bool
    @Environment(\.dismiss) var dismiss
    @State var allExperiences: [Experience] = []
    @State var selectedExperiences: Set<String> = []
    @State var tempStartDate: Date = Date()
    @State var tempEndDate: Date = Date()
    @State var alertMessage = ""
    @State var activeAlert: ActiveAlert?
    @State var showingAlert = false
    @State var showingDeleteConfirmation = false
    @State var deleteAction: () -> Void = {}
    @EnvironmentObject var userViewModel: UserViewModel
    var userData: UserModel? {
      userViewModel.getSessionData()?.userData
    }
    var api = TripsAPI()
    
    func validateExperiences() -> Bool {
        for experienceId in selectedExperiences {
            guard let experience = allExperiences.first(where: { $0.id == experienceId }) else { continue }
            let experienceDate = Date(timeIntervalSinceReferenceDate: TimeInterval(experience.date))
            if experienceDate < tempStartDate || experienceDate > tempEndDate.addingTimeInterval(24*60*60 - 1) {
                activeAlert = .experienceValidation
                alertMessage = "One or more selected experiences fall outside the trip's date range."
                return false
            }
        }
        return true
    }
    
    let dateFormatter: DateFormatter = {
           let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-MM-dd"
           formatter.timeZone = TimeZone(secondsFromGMT: 0)
           return formatter
        }()
        
    var body: some View {
            VStack {
                ZStack {
                    Color.white.edgesIgnoringSafeArea(.all)
                    Form {
                        Section(header: Text("Trip Details")) {
                            TextField("Trip Name", text: $trip.name)
                                .padding(.horizontal, 5)
                            
                            ZStack(alignment: .topLeading) {
                                if trip.description.isEmpty {
                                    Text("Describe your trip here...")
                                        .padding(.horizontal, 5)
                                        .padding(.vertical, 8)
                                }
                                
                                TextEditor(text: $trip.description)
                                    .frame(minHeight: 100)
                            }
                            
                            DatePicker(
                                "Start Date",
                                selection: $tempStartDate,
                                displayedComponents: .date
                            )
                            .environment(\.timeZone, TimeZone(secondsFromGMT: 0)!)
                            .padding(.horizontal, 5)
                            
                            DatePicker(
                                "End Date",
                                selection: $tempEndDate,
                                displayedComponents: .date
                            )
                            .environment(\.timeZone, TimeZone(secondsFromGMT: 0)!)
                            .padding(.horizontal, 5)
                        }
                        Section(header: Text("Select Experiences")) {
                            SelectExperiencesView(
                                selectedExperiences: $selectedExperiences,
                                allExperiences: allExperiences,
                                tripStartDate: tempStartDate,
                                tripEndDate: tempEndDate,
                                alertMessage: $alertMessage,
                                showingAlert: $showingAlert
                            )
                        }
                    }
                }
                .navigationBarTitle("Edit Trip", displayMode: .inline)
                
                Spacer()
                
                HStack(spacing: 40) {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Cancel")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.black)
                    .frame(width: 100, height: 40)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 2)
                    )
                    .cornerRadius(10)
                    
                    Button(action: {
                        
                        if validateExperiences() {
                            trip.startDate = dateFormatter.string(from: tempStartDate)
                            trip.endDate = dateFormatter.string(from: tempEndDate)
                            trip.experiences = Array(selectedExperiences)
                            
                            if let token = userData?.token {
                                api.updateTrip(trip: trip, token: token) { result in
                                    DispatchQueue.main.async {
                                        switch result {
                                        case .success:
                                            dismiss()
                                        case .failure(let error):
                                            switch error {
                                            case .custom(let errorMessage):
                                                alertMessage = errorMessage
                                                showingAlert = true
                                            }
                                        }
                                    }
                                }
                            } else {
                                alertMessage = "User token not available"
                                showingAlert = true
                            }
                        } else {
                            print("Experience validation failed")
                        }
                    }) {
                        Text("Save")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(width: 100, height: 40)
                    .background(Color.black)
                    .cornerRadius(10)
                }
                .padding()
                
                Button(action: {
                    activeAlert = .deleteConfirmation
                    self.deleteAction = {
                        if let token = userData?.token, let tripId = trip.id {
                            api.deleteTrip(tripId: tripId, token: token) { success in
                                DispatchQueue.main.async {
                                    if success {
                                        self.tripIsDeleted = true
                                        dismiss()
                                    } else {
                                        alertMessage = "Error - Failed to delete trip"
                                        showingAlert = true
                                    }
                                }
                            }
                        }
                    }
                }) {
                    Text("Delete Trip")
                        .fontWeight(.semibold)
                        .foregroundColor(.red)
                }
                .padding()
                .frame(width: 120, height: 40)
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.red, lineWidth: 2)
                )
            }
            .alert(item: $activeAlert) { alertType in
                    switch alertType {
                    case .experienceValidation:
                        return Alert(
                            title: Text("Error"),
                            message: Text(alertMessage),
                            dismissButton: .default(Text("OK"))
                        )
                    case .deleteConfirmation:
                        return Alert(
                            title: Text("Delete Trip"),
                            message: Text("Are you sure you want to delete this trip?"),
                            primaryButton: .destructive(Text("Delete")) { self.deleteAction() },
                            secondaryButton: .cancel()
                        )
                    }
                }
            .onAppear {
                loadExperiences()
                if let startDate = dateFormatter.date(from: trip.startDate),
                   let endDate = dateFormatter.date(from: trip.endDate) {
                    tempStartDate = startDate
                    tempEndDate = endDate
                } else {
                    tempStartDate = Date()
                    tempEndDate = Date()
                }
            }
        }

    func loadExperiences() {
        api.getExperiences { experiences in
            DispatchQueue.main.async {
                self.allExperiences = experiences
                self.selectedExperiences = Set(trip.experiences)
            }
        }
    }
}
