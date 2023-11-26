//
//  HomeScreen.swift
//  TravelApp
//
//  Created by Bryshon Sweeney on 10/25/23.
//

import SwiftUI

struct HomeScreen: View {
    var experiences: [Experience]
    @State private var registrationComplete = false
    @EnvironmentObject var userViewModel: UserViewModel
    var body: some View {
        if registrationComplete {
            
        }
        TabView {
            ExperienceScreen(experiences: experiences)
                .tabItem {
                    Label("Experiences", systemImage: "book.closed")
                }
            
            TripScreen()
                .tabItem {
                    Label("Trips", systemImage: "car")
                }
            
            UserProfileScreen()
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
        }
    }
}

#Preview {
    HomeScreen(experiences: experiences)
}
