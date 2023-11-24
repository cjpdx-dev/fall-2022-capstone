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
    
    var body: some View {
            VStack {
                Form {
                    Section(header: Text("Trip Details")) {
                        TextField("Trip Name", text: $tripName)
                            .padding(.horizontal, 5)

                        ZStack(alignment: .topLeading) {
                            if tripDescription.isEmpty {
                                Text("Describe your trip here...")
                                    .foregroundColor(Color(UIColor.placeholderText))
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
                }
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
                        let newTrip = Trip(
                            name: tripName,
                            description: tripDescription,
                            startDate: startDate,
                            endDate: endDate,
                            experiences: []
                        )
                        
                        TripsAPI().createTrip(trip: newTrip) { success in
                            DispatchQueue.main.async {
                                tripCreationResult = success
                                if success {
                                    dismiss()
                                }
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
            .background(Color(UIColor.systemGroupedBackground))
        }
    }

#Preview {
    CreateTripScreen()
}
