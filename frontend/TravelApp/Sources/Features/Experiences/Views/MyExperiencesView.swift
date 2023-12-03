//
//  MyExperiencesView.swift
//  TravelApp
//
//  Created by Bryshon Sweeney on 11/14/23.
//

import SwiftUI

struct MyExperiencesView: View {
    @State private var searchText: String = ""
    @State private var experienceData = ExperienceData()
    @EnvironmentObject var userViewModel: UserViewModel
    var userData: UserModel {
        userViewModel.getSessionData()!.userData
    }
    var token: String {
        userViewModel.getSessionData()?.userData.token ?? ""
    }
    var experienceAPI = ExperienceAPI()
    var filteredResults: [Experience] {
        if searchText.isEmpty {
            return experienceData.experiences.filter {
                $0.userID == userData.id
            }
        } else {
            return experienceData.experiences.filter {
                ($0.title.contains(searchText) ||
                $0.location.state.contains(searchText) ||
                $0.location.city.contains(searchText) ||
                $0.keywords.contains(searchText)) 
                && $0.userID == userData.id
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
                    .onDelete(perform: deleteExperience)
                    
                    
                }
                .navigationTitle("My Experiences")
                .listStyle(.plain)
                .toolbar(content: {
                    EditButton()
//                    Button {
//                        print("Editing Mode")
//                    } label: {
//                        Image(systemName: "pencil.circle.fill")
//                            .font(.system(size: 27))
//                    }
//                    .buttonStyle(PlainButtonStyle())
                    
                })
                .searchable(text: $searchText)
                .onAppear {
                    experienceData.getExperiences(token: token)
                }
            }
        }
    func deleteExperience(at offsets: IndexSet) {
        offsets.map { experienceData.experiences[$0] }.forEach { experience in
            print(experience)
            experienceAPI.deleteExperience(id: experience.id, token: token)
            experienceData.experiences.remove(atOffsets: offsets)
        }
        
    }
}

#Preview {
    MyExperiencesView(experiences: experiences)
        .environmentObject(UserViewModel())
}
