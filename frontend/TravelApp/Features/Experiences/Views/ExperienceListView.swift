//
//  ExperienceListView.swift
//  TravelApp
//
//  Created by Bryshon Sweeney on 10/27/23.
//

import SwiftUI

struct ExperienceListView: View {
    @State private var searchText: String = ""
    var experiences: [Experience]
    var body: some View {
        NavigationStack {
            List(experiences) { experience in
                NavigationLink {
                    ExperienceDetailView(experience: experience)
                } label: {
                    ExperienceRowView(experience: experience)
                }
                
                
            }
            .navigationTitle("Experiences")
            .searchable(text: $searchText)
        }
        
    }
}

#Preview {
    ExperienceListView(experiences: experiences)
}
