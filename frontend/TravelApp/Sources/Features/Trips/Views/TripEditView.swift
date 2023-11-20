//
//  TripEditView.swift
//  TravelApp
//
//  Created by Rachel Pratt on 11/2/23.
//

import SwiftUI

struct TripEditView: View {
    @Binding var trip: Trip
    @Environment(\.dismiss) var dismiss
    var onTripUpdated: () -> Void
        
    var body: some View {
            VStack {
                Form {
                    Section(header: Text("Trip Details")) {
                        TextField("Trip Name", text: $trip.name)
                            .padding(.horizontal, 5)

                        ZStack(alignment: .topLeading) {
                            if trip.description.isEmpty {
                                Text("Describe your trip here...")
                                    .foregroundColor(Color(UIColor.placeholderText))
                                    .padding(.horizontal, 5)
                                    .padding(.vertical, 8)
                            }
                            
                            TextEditor(text: $trip.description)
                                .frame(minHeight: 100)
                        }

                        DatePicker(
                            "Start Date",
                            selection: $trip.startDate,
                            displayedComponents: .date
                        )
                        .padding(.horizontal, 5)
                        
                        DatePicker(
                            "End Date",
                            selection: $trip.endDate,
                            displayedComponents: .date
                        )
                        .padding(.horizontal, 5)
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
                        TripsAPI().updateTrip(trip: trip) { success in
                            DispatchQueue.main.async {
                                if success {
                                    // Show an alert "Trip saved"
                                    onTripUpdated()
                                    dismiss()
                                } else {
                                    // Show an error message to user
                                    print("Error - Failed to update trip")
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
                
                Button(action: {
                    TripsAPI().deleteTrip(tripId: trip.id ?? "") { success in
                        DispatchQueue.main.async {
                            if success {
                                // Take user back to TripScreen page
                                dismiss()
                            } else {
                                print("Error - Failed to delete trip")
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
            .background(Color(UIColor.systemGroupedBackground))
        }
}

#Preview {
    TripEditView(trip: .constant(Trip(id: "1234", name: "Sample Trip", description: "This is a sample description", startDate: DateComponents(calendar: .current, year: 2023, month: 1, day: 15).date!, endDate: DateComponents(calendar: .current, year: 2023, month: 1, day: 22).date!, user: "Sample User")), onTripUpdated: { })
}
