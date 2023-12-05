//
//  CreateTripScreen.swift
//  TravelApp
//
//  Created by Rachel Pratt on 11/2/23.
//

import SwiftUI
import Combine

struct CreateTripScreen: View {
    @State private var tripName: String = ""
    @State private var tripDescription: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @Environment(\.dismiss) var dismiss
    @State private var tripCreationResult: Bool? = nil
    @State private var allExperiences: [Experience] = []
    @State private var selectedExperiences: Set<String> = []
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @EnvironmentObject var userViewModel: UserViewModel
    private var userData: UserModel? {
        userViewModel.getSessionData()?.userData
    }
    var api = TripsAPI()
    
    private func validateExperiences() -> Bool {
        for experienceId in selectedExperiences {
            guard let experience = allExperiences.first(where: { $0.id == experienceId }) else { continue }
            let experienceDate = Date(timeIntervalSinceReferenceDate: TimeInterval(experience.date))
            if experienceDate < startDate || experienceDate > endDate {
                alertMessage = "One or more selected experiences fall outside the trip's date range."
                showingAlert = true
                return false
            }
        }
        return true
    }
    
    var body: some View {
            VStack {
                ZStack {
                    Color.white.edgesIgnoringSafeArea(.all)
                    Form {
                        Section(header: Text("Trip Details")) {
                            TextField("Trip Name", text: $tripName)
                                .padding(.horizontal, 5)
                            
                            ZStack(alignment: .topLeading) {
                                if tripDescription.isEmpty {
                                    Text("Describe your trip here...")
                                        .padding(.horizontal, 5)
                                        .padding(.vertical, 8)
                                }
                                
                                TextEditor(text: $tripDescription)
                                    .frame(minHeight: 100)
                            }
                            
                            DatePicker(
                                "Start Date",
                                selection: $startDate,
                                displayedComponents: .date
                            )
                            .padding(.horizontal, 5)
                            
                            DatePicker(
                                "End Date",
                                selection: $endDate,
                                displayedComponents: .date
                            )
                            .padding(.horizontal, 5)
                        }
                        Section(header: Text("Select Experiences")) {
                            SelectExperiencesView(
                                selectedExperiences: $selectedExperiences,
                                allExperiences: allExperiences,
                                tripStartDate: startDate,
                                tripEndDate: endDate,
                                alertMessage: $alertMessage,
                                showingAlert: $showingAlert
                            )
                        }
                    }
                }
                .background(Color.white.edgesIgnoringSafeArea(.all))
                .navigationBarTitle("Create Trip", displayMode: .inline)
                
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
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd"
                            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                            let formattedStartDate = dateFormatter.string(from: startDate)
                            let formattedEndDate = dateFormatter.string(from: endDate)
                            
                            let newTrip = Trip(
                                name: tripName,
                                description: tripDescription,
                                startDate: formattedStartDate,
                                endDate: formattedEndDate,
                                user: userData?.id ?? "",
                                experiences: Array(selectedExperiences)
                            )
                            
                            
                            if let token = userData?.token {
                                print("User token: \(token)")
                                api.createTrip(trip: newTrip, token: token) { result in
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
                                print("User token not available")
                                showingAlert = true
                            }
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
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .onAppear(perform: loadExperiences)
        }
    private func loadExperiences() {
        api.getExperiences { experiences in
            DispatchQueue.main.async {
                self.allExperiences = experiences
                self.selectedExperiences = []
            }
        }
    }
}

#Preview {
    CreateTripScreen()
}
