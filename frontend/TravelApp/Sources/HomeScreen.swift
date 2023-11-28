//
//  HomeScreen.swift
//  TravelApp
//
//  Created by Bryshon Sweeney on 10/25/23.
//

import SwiftUI

struct HomeScreen: View {
    var experiences: [Experience]
    
    @EnvironmentObject var userViewModel:  UserViewModel
    
    var body: some View {

        TabView {
            ExperienceScreen(experiences: experiences)
                .tabItem {
                    Label("Experiences", systemImage: "book.closed")
                }
                .environmentObject(userViewModel)
            
            TripScreen()
                .tabItem {
                    Label("Trips", systemImage: "car")
                }
                .environmentObject(userViewModel)
            
            UserProfileScreen()
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
                .environmentObject(userViewModel)
        }
    }
}

#Preview {
    HomeScreen(experiences: experiences)
}
