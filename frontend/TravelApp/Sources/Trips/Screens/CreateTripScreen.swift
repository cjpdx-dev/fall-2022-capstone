//
//  CreateTripScreen.swift
//  TravelApp
//
//  Created by Rachel Pratt on 11/2/23.
//

import SwiftUI

struct CreateTripScreen: View {
    @State private var tripName: String = ""
    @State private var tripDescription: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @Environment(\.dismiss) var dismiss
    
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
    CreateTripScreen()
}
