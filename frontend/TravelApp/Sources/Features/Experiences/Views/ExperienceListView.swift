//
//  ExperienceListView.swift
//  TravelApp
//
//  Created by Bryshon Sweeney on 10/27/23.
//

import SwiftUI

struct ExperienceListView: View {
    @State private var searchText: String = ""
    @State private var experienceData = ExperienceData()
    var experiences: [Experience]
    var body: some View {
        NavigationStack {
            List(experiences) { experience in
                NavigationLink {
                    ExperienceDetailView(experience: experience)
                        .navigationBarBackButtonHidden(true)
                        
                } label: {
                    ExperienceRowView(experience: experience)
                }
            }
            .navigationTitle("Experiences")
            .listStyle(.plain)
            .toolbar(content: {
                NavigationLink {
                    CreateExperienceScreen()
                        .navigationTitle("Create Experience")
                        .navigationBarBackButtonHidden()
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 27))
                }
                .buttonStyle(PlainButtonStyle())
                
            })
            .searchable(text: $searchText)
            
        }
        
    }
}

#Preview {
    ExperienceListView(experiences: experiences)
}
