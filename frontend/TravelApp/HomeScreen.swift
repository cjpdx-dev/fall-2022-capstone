//
//  HomeScreen.swift
//  TravelApp
//
//  Created by Bryshon Sweeney on 10/25/23.
//

import SwiftUI

struct HomeScreen: View {
    var body: some View {
        TabView {
            ExperienceScreen()
                .tabItem {
                    Label("Experiences", systemImage: "book.closed")
                }
            
            Text("Second Tab")
                .tabItem {
                    Label("Trips", systemImage: "car")
                }
            
            Text("Third Tab")
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
        }
        
    }
}

#Preview {
    HomeScreen()
}
