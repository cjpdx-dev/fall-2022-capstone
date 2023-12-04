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
    
    // This is the user's session
    @EnvironmentObject var userViewModel:  UserViewModel
    // This is the user's data that is pulled from the user's session
    // You could access the session token "token" by calling...
    //      token = userData.token
    var token: String {
        userViewModel.getSessionData()?.userData.token ?? ""
    }
    
    var filteredResults: [Experience] {
        if searchText.isEmpty {
            return experienceData.experiences
        } else {
            return experienceData.experiences.filter {
                $0.title.lowercased().contains(searchText.lowercased()) ||
                $0.location.state.lowercased().contains(searchText.lowercased()) ||
                $0.location.city.lowercased().contains(searchText.lowercased()) ||
                $0.keywords.contains(searchText.lowercased())
            }
        }
    }
    var experiences: [Experience]
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredResults) { experience in
                    NavigationLink {
                        ExperienceDetailView(experience: experience)
                            .navigationBarBackButtonHidden(true)
                            
                    } label: {
                        ExperienceRowView(experience: experience)
                    }
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
            .onAppear {
                experienceData.getExperiences(token: token)
            }
        }
    }
}

#Preview {
    ExperienceListView(experiences: experiences)
        .environmentObject(UserViewModel())
}
