//
//  TripEditView.swift
//  TravelApp
//
//  Created by Rachel Pratt on 11/2/23.
//

import SwiftUI

struct TripEditView: View {
//    @Binding var trip: Trip
    var trip: Trip
    @State private var tripName: String
    @State private var tripDescription: String
    @State private var startDate: Date
    @State private var endDate: Date
    @Environment(\.dismiss) var dismiss
    
    init(trip: Trip) {
            self.trip = trip
            _tripName = State(initialValue: trip.name)
            _tripDescription = State(initialValue: trip.description)
            _startDate = State(initialValue: trip.startDate)
            _endDate = State(initialValue: trip.endDate)
        }
    
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
                    .border(Color.black)
                    .background(Color.white)
                    
                    Button(action: {
                        print("Saved")
                    }) {
                        Text("Save")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(width: 100, height: 40)
                    .background(Color.black)
                }
                .padding()
            }
            .background(Color(UIColor.systemGroupedBackground))
        }
}

#Preview {
    TripEditView(trip: Trip(id: "1234", name: "Sample Trip", description: "This is a sample description", startDate: DateComponents(calendar: .current, year: 2023, month: 1, day: 15).date!, endDate: DateComponents(calendar: .current, year: 2023, month: 1, day: 22).date!, user: "Sample User"))
}
