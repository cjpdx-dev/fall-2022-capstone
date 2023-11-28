//
//  TravelAppApp.swift
//  TravelApp
//
//  Created by Bryshon Sweeney on 10/24/23.
//

import SwiftUI

@main
struct TravelAppApp: App {
    @StateObject private var userViewModel = UserViewModel()
    var body: some Scene {
        WindowGroup {
            if userViewModel.isLoggedIn {
                HomeScreen(experiences: experiences)
                    .environmentObject(userViewModel)
            }
            else {
                LoginScreen()
                    .environmentObject(userViewModel)
            }
        }
    }
}

#Preview {
    HomeScreen(experiences:experiences)
}
