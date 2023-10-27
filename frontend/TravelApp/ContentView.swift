//
//  ContentView.swift
//  TravelApp
//
//  Created by Bryshon Sweeney on 10/24/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            NavigationLink {
                // Destination View to navigate to
                ExperienceScreen()
            } label: {
                AuthScreen()
            }
            
        }
    }
}

#Preview {
    ContentView()
}
